table 50105 "Notification"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Title; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Message; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
        field(5; "Created At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Sent At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(7; "User ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "User"."User ID";
        }
        field(8; "Service ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Service."Service ID";
        }
        field(9; "Template ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Template."Template ID";
        }
        field(10; Status; Enum "Notification Status")
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Notification ID")
        {
            Clustered = true;
        }
    }
}
