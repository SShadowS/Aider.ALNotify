/// <summary>
/// Codeunit 50103 "Pushbullet Notification Protocol".
/// Implements the INotificationProtocol interface for sending notifications via Pushbullet.
/// </summary>
codeunit 50103 "Pushbullet Notification Protocol" implements INotificationProtocol
{
    var
        ErrorLogging: Codeunit "Error Logging";

    /// <summary>
    /// Sends a notification using the Pushbullet API.
    /// </summary>
    /// <param name="Notification">The notification record to send.</param>
    /// <param name="ErrorMessage">Output parameter for any error messages.</param>
    /// <returns>True if the notification was sent successfully, false otherwise.</returns>
    procedure SendNotification(Notification: Record Notification; var ErrorMessage: Text): Boolean
    var
        Pushbullet: Record Pushbullet;
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        JsonText: Text;
    begin
        if not Pushbullet.Get(Notification."Protocol ID") then
        begin
            ErrorMessage := 'Pushbullet configuration not found.';
            ErrorLogging.LogError('PushbulletNotificationProtocol.SendNotification', ErrorMessage, Format(Notification."Protocol ID"));
            exit(false);
        end;

        JsonObject.Add('type', 'note');
        JsonObject.Add('title', Notification.Title);
        JsonObject.Add('body', Notification.Message);

        if Pushbullet.Email <> '' then
            JsonObject.Add('email', Pushbullet.Email)
        else if Pushbullet."Device Iden" <> '' then
            JsonObject.Add('device_iden', Pushbullet."Device Iden")
        else if Pushbullet."Channel Tag" <> '' then
            JsonObject.Add('channel_tag', Pushbullet."Channel Tag");

        JsonObject.WriteTo(JsonText);

        HttpContent.WriteFrom(JsonText);
        HttpContent.GetHeaders().Add('Content-Type', 'application/json');
        HttpContent.GetHeaders().Add('Access-Token', Pushbullet."Access Token");

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri('https://api.pushbullet.com/v2/pushes');
        HttpRequestMessage.Content(HttpContent);

        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then
        begin
            ErrorMessage := 'Failed to send Pushbullet notification.';
            exit(false);
        end;

        if not HttpResponseMessage.IsSuccessStatusCode then
        begin
            ErrorMessage := StrSubstNo('Pushbullet API returned error: %1 %2', 
                HttpResponseMessage.HttpStatusCode, 
                HttpResponseMessage.ReasonPhrase);
            exit(false);
        end;

        exit(true);
    end;
}
