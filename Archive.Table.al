table 50106 "Archive"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Archive ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
        field(3; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
        field(4; "Sent At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Archive ID")
        {
            Clustered = true;
        }
    }
}
