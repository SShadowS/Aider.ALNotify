enum 50101 "Notification Status"
{
    Extensible = true;
    
    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Sent)
    {
        Caption = 'Sent';
    }
    value(2; Failed)
    {
        Caption = 'Failed';
    }
    value(3; Canceled)
    {
        Caption = 'Canceled';
    }
}
