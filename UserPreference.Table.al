table 50110 "User Preference"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Preference ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "User ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "User"."User ID";
        }
        field(3; "Event ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Event."Event ID";
        }
        field(4; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
        field(5; "Is Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; Frequency; Enum "Notification Frequency")
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Preference ID")
        {
            Clustered = true;
        }
    }
}
