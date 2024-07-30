table 50100 "User"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "User ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Username; Text[50])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataValidation: Codeunit "Data Validation";
            begin
                Username := DataValidation.SanitizeText(Username, 50);
            end;
        }
        field(3; Email; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataValidation: Codeunit "Data Validation";
            begin
                if not DataValidation.ValidateEmail(Email) then
                    Error('Invalid email address');
            end;
        }
        field(4; "Is Active"; Boolean)
        {
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(5; "Last Login"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
        key(Username; Username)
        {
            Unique = true;
        }
        key(Email; Email)
        {
            Unique = true;
        }
    }
}
