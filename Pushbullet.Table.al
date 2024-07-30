table 50108 "Pushbullet"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Pushbullet ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Access Token"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Device Iden"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; Email; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Channel Tag"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
    }
    
    keys
    {
        key(PK; "Pushbullet ID")
        {
            Clustered = true;
        }
    }
}
