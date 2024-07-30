table 50115 "User Rate Limit"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Rate Limit ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "User ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "User"."User ID";
        }
        field(3; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
        field(4; "Max Notifications"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Time Window"; Duration)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Current Count"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Last Reset"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Rate Limit ID")
        {
            Clustered = true;
        }
    }
}
