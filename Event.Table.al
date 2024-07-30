table 50104 "Event"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Event ID"; Integer)
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
        key(PK; "Event ID")
        {
            Clustered = true;
        }
        key(Name; Name)
        {
            Unique = true;
        }
    }
}
