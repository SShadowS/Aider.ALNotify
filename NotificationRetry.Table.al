table 50111 "Notification Retry"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Retry ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
        field(3; "Retry Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Next Retry At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Last Error"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Retry ID")
        {
            Clustered = true;
        }
    }
}
