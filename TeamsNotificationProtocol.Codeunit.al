codeunit 50102 "Teams Notification Protocol" implements INotificationProtocol
{
    var
        ErrorLogging: Codeunit "Error Logging";

    procedure SendNotification(Notification: Record Notification; var ErrorMessage: Text): Boolean
    var
        Teams: Record Teams;
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if not Teams.Get(Notification."Protocol ID") then
        begin
            ErrorMessage := 'Teams configuration not found.';
            ErrorLogging.LogError('TeamsNotificationProtocol.SendNotification', ErrorMessage, Format(Notification."Protocol ID"));
            exit(false);
        end;

        JsonObject.Add('text', Notification.Message);
        JsonObject.WriteTo(JsonText);

        HttpContent.WriteFrom(JsonText);
        HttpContent.GetHeaders().Add('Content-Type', 'application/json');

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(Teams."Webhook URL");
        HttpRequestMessage.Content(HttpContent);

        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
        begin
            ErrorMessage := 'Failed to send Teams notification.';
            ErrorLogging.LogError('TeamsNotificationProtocol.SendNotification', ErrorMessage, Format(Notification));
            exit(false);
        end;

        if not HttpResponseMessage.IsSuccessStatusCode then
        begin
            ErrorMessage := StrSubstNo('Teams API returned error: %1 %2', 
                HttpResponseMessage.HttpStatusCode, 
                HttpResponseMessage.ReasonPhrase);
            ErrorLogging.LogError('TeamsNotificationProtocol.SendNotification', ErrorMessage, Format(Notification));
            exit(false);
        end;

        exit(true);
    end;
}
