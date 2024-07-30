/// <summary>
/// Codeunit 50101 "Notification Retry Manager".
/// Manages the retry mechanism for failed notifications, including creating retry entries and processing retries.
/// </summary>
codeunit 50101 "Notification Retry Manager"
{
    var
        ErrorLogging: Codeunit "Error Logging";

    /// <summary>
    /// Creates a retry entry for a failed notification.
    /// </summary>
    /// <param name="NotificationID">The ID of the failed notification.</param>
    /// <param name="ErrorMessage">The error message associated with the failure.</param>
    procedure CreateRetryEntry(NotificationID: Integer; ErrorMessage: Text)
    var
        NotificationRetry: Record "Notification Retry";
    begin
        NotificationRetry.Init();
        NotificationRetry."Notification ID" := NotificationID;
        NotificationRetry."Retry Count" := 0;
        NotificationRetry."Next Retry At" := CalcDate('<+15M>', CurrentDateTime);
        NotificationRetry."Last Error" := CopyStr(ErrorMessage, 1, MaxStrLen(NotificationRetry."Last Error"));
        if not NotificationRetry.Insert() then
            ErrorLogging.LogError('NotificationRetryManager.CreateRetryEntry', 'Failed to create retry entry', Format(NotificationID));
    end;

    /// <summary>
    /// Processes all pending retry entries, attempting to resend failed notifications.
    /// </summary>
    procedure ProcessRetries()
    var
        NotificationRetry: Record "Notification Retry";
        NotificationManager: Codeunit "Notification Manager";
    begin
        NotificationRetry.SetFilter("Next Retry At", '<=%1', CurrentDateTime);
        if NotificationRetry.FindSet() then
            repeat
                if NotificationManager.SendNotification(NotificationRetry."Notification ID") then
                    NotificationRetry.Delete()
                else
                begin
                    UpdateRetryEntry(NotificationRetry);
                    ErrorLogging.LogError('NotificationRetryManager.ProcessRetries', 'Retry failed', Format(NotificationRetry));
                end;
            until NotificationRetry.Next() = 0;
    end;

    local procedure UpdateRetryEntry(var NotificationRetry: Record "Notification Retry")
    begin
        NotificationRetry."Retry Count" +=1;
        NotificationRetry."Next Retry At" := CalcDate(GetRetryInterval(NotificationRetry."Retry Count"), CurrentDateTime);
        if not NotificationRetry.Modify() then
            ErrorLogging.LogError('NotificationRetryManager.UpdateRetryEntry', 'Failed to update retry entry', Format(NotificationRetry));
    end;

    local procedure GetRetryInterval(RetryCount: Integer): Text
    begin
        case RetryCount of
            1..3:
                exit('<+30M>');
            4..6:
                exit('<+1H>');
            7..10:
                exit('<+4H>');
            else
                exit('<+1D>');
        end;
    end;
}
