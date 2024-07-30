interface "INotificationProtocol"
{
    procedure SendNotification(Notification: Record Notification; var ErrorMessage: Text): Boolean;
}
