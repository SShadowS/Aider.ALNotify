table 50102 "Protocol"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Endpoint; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Implementation Class"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Protocol ID")
        {
            Clustered = true;
        }
        key(Name; Name)
        {
            Unique = true;
        }
    }

    procedure InsertDefaultProtocols()
    begin
        if IsEmpty then
        begin
            Init();
            Name := 'Teams';
            "Implementation Class" := 'Teams Notification Protocol';
            Insert();

            Init();
            Name := 'Pushbullet';
            "Implementation Class" := 'Pushbullet Notification Protocol';
            Insert();
        end;
    end;
}
