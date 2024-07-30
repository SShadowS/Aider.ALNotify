table 50117 "Notification Analytics"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Analytics ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
        field(3; "Delivered At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Opened At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Clicked At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Analytics ID")
        {
            Clustered = true;
        }
    }
}
