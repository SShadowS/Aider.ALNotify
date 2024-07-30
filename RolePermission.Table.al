table 50120 "Role Permission"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Permission ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Role ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Role."Role ID";
        }
        field(3; "Event ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Event."Event ID";
        }
        field(4; "Can Send"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Permission ID")
        {
            Clustered = true;
        }
    }
}
