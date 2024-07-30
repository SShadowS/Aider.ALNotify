table 50119 "User Role"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "User Role ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "User ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "User"."User ID";
        }
        field(3; "Role ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Role."Role ID";
        }
    }
    
    keys
    {
        key(PK; "User Role ID")
        {
            Clustered = true;
        }
    }
}
