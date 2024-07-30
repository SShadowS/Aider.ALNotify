table 50112 "Notification Group"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Group ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Group ID")
        {
            Clustered = true;
        }
    }
}
