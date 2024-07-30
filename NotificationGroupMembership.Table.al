table 50113 "Notification Group Membership"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Membership ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Group ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Notification Group"."Group ID";
        }
        field(3; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
    }
    
    keys
    {
        key(PK; "Membership ID")
        {
            Clustered = true;
        }
    }
}
