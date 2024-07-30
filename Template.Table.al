table 50103 "Template"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Template ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataValidation: Codeunit "Data Validation";
            begin
                Name := DataValidation.SanitizeText(Name, 100);
            end;
        }
        field(3; Content; Blob)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
        field(5; "Service ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Service."Service ID";
        }
        field(6; "Content Type"; Enum "Content Type")
        {
            DataClassification = CustomerContent;
        }
        field(7; Attachments; Text[2048])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataValidation: Codeunit "Data Validation";
            begin
                Attachments := DataValidation.SanitizeText(Attachments, 2048);
            end;
        }
        field(8; "Dynamic Fields"; Text[2048])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                DataValidation: Codeunit "Data Validation";
            begin
                "Dynamic Fields" := DataValidation.SanitizeText("Dynamic Fields", 2048);
            end;
        }
        field(9; "Created At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Last Modified"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Version"; Integer)
        {
            DataClassification = CustomerContent;
            InitValue = 1;
        }
    }
    
    keys
    {
        key(PK; "Template ID")
        {
            Clustered = true;
        }
    }
}
