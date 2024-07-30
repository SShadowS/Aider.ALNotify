codeunit 50104 "Data Validation"
{
    procedure SanitizeText(InputText: Text; MaxLength: Integer): Text
    var
        SanitizedText: Text;
    begin
        SanitizedText := DelChr(InputText, '=', '<>&"''');
        if StrLen(SanitizedText) > MaxLength then
            SanitizedText := CopyStr(SanitizedText, 1, MaxLength);
        exit(SanitizedText);
    end;

    procedure ValidateEmail(Email: Text): Boolean
    var
        EmailRegex: Codeunit Regex;
    begin
        exit(EmailRegex.IsMatch(Email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'));
    end;

    procedure ValidateURL(URL: Text): Boolean
    var
        URLRegex: Codeunit Regex;
    begin
        exit(URLRegex.IsMatch(URL, '^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'));
    end;
}
