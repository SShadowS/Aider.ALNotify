table 50107 "Notification Event"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Notification Event ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
        field(3; "Event ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Event."Event ID";
        }
    }
    
    keys
    {
        key(PK; "Notification Event ID")
        {
            Clustered = true;
        }
    }
}
