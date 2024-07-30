table 50121 "Error Log"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Date and Time"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(3; Source; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Error Message"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Additional Info"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
