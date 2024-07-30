table 50114 "Template Localization"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Localization ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Template ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Template."Template ID";
        }
        field(3; "Language Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Language.Code;
        }
        field(4; "Localized Content"; Blob)
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Localization ID")
        {
            Clustered = true;
        }
    }
}
