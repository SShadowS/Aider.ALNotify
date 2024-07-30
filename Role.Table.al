table 50118 "Role"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Role ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Role ID")
        {
            Clustered = true;
        }
    }
}
