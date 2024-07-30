/// <summary>
/// Codeunit 50100 "Notification Manager".
/// Manages the core functionality of the notification system, including sending notifications, checking user preferences and permissions, and handling rate limits.
/// </summary>
codeunit 50100 "Notification Manager"
{
    var
        ErrorLogging: Codeunit "Error Logging";

    /// <summary>
    /// Sends a notification based on the given Notification ID.
    /// </summary>
    /// <param name="NotificationID">The ID of the notification to send.</param>
    /// <returns>True if the notification was sent successfully, false otherwise.</returns>
    procedure SendNotification(NotificationID: Integer): Boolean
    var
        Notification: Record Notification;
        UserPreference: Record "User Preference";
        UserRateLimit: Record "User Rate Limit";
        Protocol: Record Protocol;
        Template: Record Template;
        TemplateLocalization: Record "Template Localization";
        NotificationRetryManager: Codeunit "Notification Retry Manager";
        ErrorMessage: Text;
    begin
        if not Notification.Get(NotificationID) then
        begin
            ErrorMessage := 'Notification not found.';
            ErrorLogging.LogError('NotificationManager.SendNotification', ErrorMessage, Format(NotificationID));
            Error(ErrorMessage);
        end;

        if not CheckUserPermission(Notification) then
        begin
            ErrorLogging.LogError('NotificationManager.SendNotification', 'User does not have permission', Format(Notification));
            exit(false);
        end;

        if not CheckUserPreference(Notification) then
        begin
            ErrorLogging.LogError('NotificationManager.SendNotification', 'User preference check failed', Format(Notification));
            exit(false);
        end;

        if not CheckUserRateLimit(Notification) then
        begin
            ErrorLogging.LogError('NotificationManager.SendNotification', 'User rate limit exceeded', Format(Notification));
            exit(false);
        end;

        if not Protocol.Get(Notification."Protocol ID") then
        begin
            ErrorMessage := 'Protocol not found.';
            ErrorLogging.LogError('NotificationManager.SendNotification', ErrorMessage, Format(Notification."Protocol ID"));
            Error(ErrorMessage);
        end;

        if not Template.Get(Notification."Template ID") then
        begin
            ErrorMessage := 'Template not found.';
            ErrorLogging.LogError('NotificationManager.SendNotification', ErrorMessage, Format(Notification."Template ID"));
            Error(ErrorMessage);
        end;

        PopulateNotificationContent(Notification, Template, TemplateLocalization);

        if not SendNotificationViaProtocol(Notification, Protocol, ErrorMessage) then
        begin
            UpdateNotificationStatus(Notification, Notification.Status::Failed);
            NotificationRetryManager.CreateRetryEntry(NotificationID, ErrorMessage);
            ErrorLogging.LogError('NotificationManager.SendNotification', 'Failed to send notification', ErrorMessage);
            exit(false);
        end;

        UpdateNotificationStatus(Notification, Notification.Status::Sent);
        ArchiveNotification(Notification);
        CreateAnalyticsEntry(Notification);
        exit(true);
    end;

    /// <summary>
    /// Sends a notification using the specified protocol.
    /// </summary>
    /// <param name="Notification">The notification record to send.</param>
    /// <param name="Protocol">The protocol record to use for sending.</param>
    /// <param name="ErrorMessage">Output parameter for any error messages.</param>
    /// <returns>True if the notification was sent successfully, false otherwise.</returns>
    local procedure SendNotificationViaProtocol(Notification: Record Notification; Protocol: Record Protocol; var ErrorMessage: Text): Boolean
    var
        ProtocolImpl: Interface "INotificationProtocol";
        ProtocolImplClass: Text;
    begin
        ProtocolImplClass := Protocol."Implementation Class";
        if ProtocolImplClass = '' then
        begin
            ErrorMessage := StrSubstNo('No implementation class specified for protocol: %1', Protocol.Name);
            exit(false);
        end;

        if not CodeUnit.Get(ProtocolImplClass, ProtocolImpl) then
        begin
            ErrorMessage := StrSubstNo('Failed to instantiate implementation class for protocol: %1', Protocol.Name);
            exit(false);
        end;

        exit(ProtocolImpl.SendNotification(Notification, ErrorMessage));
    end;

    local procedure CheckUserPermission(Notification: Record Notification): Boolean
    var
        UserRole: Record "User Role";
        RolePermission: Record "Role Permission";
        EventID: Integer;
    begin
        EventID := GetEventIDForNotification(Notification."Notification ID");
        UserRole.SetRange("User ID", Notification."User ID");
        if UserRole.FindSet() then
            repeat
                RolePermission.SetRange("Role ID", UserRole."Role ID");
                RolePermission.SetRange("Event ID", EventID);
                RolePermission.SetRange("Can Send", true);
                if not RolePermission.IsEmpty() then
                    exit(true);
            until UserRole.Next() = 0;

        exit(false);
    end;

    local procedure CheckUserPreference(Notification: Record Notification): Boolean
    var
        UserPreference: Record "User Preference";
        EventID: Integer;
    begin
        EventID := GetEventIDForNotification(Notification."Notification ID");
        UserPreference.SetRange("User ID", Notification."User ID");
        UserPreference.SetRange("Event ID", EventID);
        UserPreference.SetRange("Protocol ID", Notification."Protocol ID");
        UserPreference.SetRange("Is Enabled", true);

        if UserPreference.IsEmpty then
            exit(false);

        if UserPreference.FindFirst() then
            exit(CheckNotificationFrequency(UserPreference, Notification));

        exit(true);
    end;

    local procedure CheckNotificationFrequency(UserPreference: Record "User Preference"; Notification: Record Notification): Boolean
    var
        LastNotification: Record Notification;
    begin
        case UserPreference.Frequency of
            UserPreference.Frequency::Immediate:
                exit(true);
            UserPreference.Frequency::Daily:
                begin
                    LastNotification.SetRange("User ID", Notification."User ID");
                    LastNotification.SetRange("Protocol ID", Notification."Protocol ID");
                    LastNotification.SetFilter("Sent At", '>=%1', CreateDateTime(CalcDate('<-1D>', Today), 0T));
                    exit(LastNotification.IsEmpty);
                end;
            UserPreference.Frequency::Weekly:
                begin
                    LastNotification.SetRange("User ID", Notification."User ID");
                    LastNotification.SetRange("Protocol ID", Notification."Protocol ID");
                    LastNotification.SetFilter("Sent At", '>=%1', CreateDateTime(CalcDate('<-1W>', Today), 0T));
                    exit(LastNotification.IsEmpty);
                end;
        end;
    end;

    local procedure CheckUserRateLimit(Notification: Record Notification): Boolean
    var
        UserRateLimit: Record "User Rate Limit";
    begin
        UserRateLimit.SetRange("User ID", Notification."User ID");
        UserRateLimit.SetRange("Protocol ID", Notification."Protocol ID");

        if UserRateLimit.FindFirst() then
        begin
            if (UserRateLimit."Current Count" >= UserRateLimit."Max Notifications") and
               (CurrentDateTime - UserRateLimit."Last Reset" <= UserRateLimit."Time Window")
            then
                exit(false);

            UserRateLimit."Current Count" += 1;
            if CurrentDateTime - UserRateLimit."Last Reset" > UserRateLimit."Time Window" then
            begin
                UserRateLimit."Current Count" := 1;
                UserRateLimit."Last Reset" := CurrentDateTime;
            end;
            UserRateLimit.Modify();
        end;

        exit(true);
    end;

    local procedure PopulateNotificationContent(var Notification: Record Notification; Template: Record Template; var TemplateLocalization: Record "Template Localization")
    var
        User: Record User;
        TempBlob: Codeunit "Temp Blob";
        DataValidation: Codeunit "Data Validation";
        InStream: InStream;
        OutStream: OutStream;
        Content: Text;
    begin
        if User.Get(Notification."User ID") then
        begin
            TemplateLocalization.SetRange("Template ID", Template."Template ID");
            TemplateLocalization.SetRange("Language Code", User."Language Code");
            if TemplateLocalization.FindFirst() then
                TemplateLocalization."Localized Content".CreateInStream(InStream)
            else
                Template.Content.CreateInStream(InStream);
        end
        else
            Template.Content.CreateInStream(InStream);

        TempBlob.CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        TempBlob.CreateInStream(InStream);
        InStream.ReadText(Content);

        // Here you would replace placeholders in the Content with actual data
        // For example: Content := Content.Replace('{UserName}', DataValidation.SanitizeText(User.Username, 50));

        Content := DataValidation.SanitizeText(Content, MaxStrLen(Notification.Message));
        Notification.Message := CopyStr(Content, 1, MaxStrLen(Notification.Message));
        Notification.Modify();
    end;

    local procedure SendPushbulletNotification(Notification: Record Notification)
    var
        Pushbullet: Record Pushbullet;
    begin
        // Implementation for sending Pushbullet notification
    end;

    local procedure SendTeamsNotification(Notification: Record Notification)
    var
        Teams: Record Teams;
    begin
        // Implementation for sending Teams notification
    end;

    local procedure UpdateNotificationStatus(var Notification: Record Notification; NewStatus: Enum "Notification Status")
    begin
        Notification.Status := NewStatus;
        Notification."Sent At" := CurrentDateTime;
        Notification.Modify();
    end;

    local procedure ArchiveNotification(Notification: Record Notification)
    var
        Archive: Record Archive;
    begin
        Archive.Init();
        Archive."Notification ID" := Notification."Notification ID";
        Archive."Protocol ID" := Notification."Protocol ID";
        Archive."Sent At" := CurrentDateTime;
        Archive.Insert();
    end;

    local procedure CreateAnalyticsEntry(Notification: Record Notification)
    var
        NotificationAnalytics: Record "Notification Analytics";
    begin
        NotificationAnalytics.Init();
        NotificationAnalytics."Notification ID" := Notification."Notification ID";
        NotificationAnalytics."Delivered At" := CurrentDateTime;
        NotificationAnalytics.Insert();
    end;

    local procedure GetEventIDForNotification(NotificationID: Integer): Integer
    var
        NotificationEvent: Record "Notification Event";
    begin
        NotificationEvent.SetRange("Notification ID", NotificationID);
        if NotificationEvent.FindFirst() then
            exit(NotificationEvent."Event ID");
        
        exit(0);
    end;

    /// <summary>
    /// Schedules a notification to be sent at a later time.
    /// </summary>
    /// <param name="NotificationID">The ID of the notification to schedule.</param>
    /// <param name="ScheduledAt">The date and time when the notification should be sent.</param>
    /// <param name="Recurrence">The recurrence pattern for the scheduled notification.</param>
    procedure ScheduleNotification(NotificationID: Integer; ScheduledAt: DateTime; Recurrence: Enum "Notification Recurrence")
    var
        ScheduledNotification: Record "Scheduled Notification";
    begin
        ScheduledNotification.Init();
        ScheduledNotification."Notification ID" := NotificationID;
        ScheduledNotification."Scheduled At" := ScheduledAt;
        ScheduledNotification.Recurrence := Recurrence;
        ScheduledNotification.Insert();
    end;

    procedure ProcessScheduledNotifications()
    var
        ScheduledNotification: Record "Scheduled Notification";
    begin
        ScheduledNotification.SetFilter("Scheduled At", '<=%1', CurrentDateTime);
        if ScheduledNotification.FindSet() then
            repeat
                SendNotification(ScheduledNotification."Notification ID");
                UpdateScheduledNotification(ScheduledNotification);
            until ScheduledNotification.Next() = 0;
    end;

    local procedure UpdateScheduledNotification(var ScheduledNotification: Record "Scheduled Notification")
    begin
        case ScheduledNotification.Recurrence of
            ScheduledNotification.Recurrence::None:
                ScheduledNotification.Delete();
            ScheduledNotification.Recurrence::Daily:
                ScheduledNotification."Scheduled At" := CalcDate('<+1D>', ScheduledNotification."Scheduled At");
            ScheduledNotification.Recurrence::Weekly:
                ScheduledNotification."Scheduled At" := CalcDate('<+1W>', ScheduledNotification."Scheduled At");
            ScheduledNotification.Recurrence::Monthly:
                ScheduledNotification."Scheduled At" := CalcDate('<+1M>', ScheduledNotification."Scheduled At");
        end;

        if not ScheduledNotification.IsEmpty then
            ScheduledNotification.Modify();
    end;
}
