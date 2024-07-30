/// <summary>
/// Codeunit 50105 "Error Logging".
/// Provides functionality for logging errors and retrieving the last error.
/// </summary>
codeunit 50105 "Error Logging"
{
    /// <summary>
    /// Logs an error to the Error Log table.
    /// </summary>
    /// <param name="Source">The source of the error.</param>
    /// <param name="ErrorMessage">The error message.</param>
    /// <param name="AdditionalInfo">Additional information about the error.</param>
    procedure LogError(Source: Text; ErrorMessage: Text; AdditionalInfo: Text)
    var
        ErrorLog: Record "Error Log";
    begin
        ErrorLog.Init();
        ErrorLog."Entry No." := 0;
        ErrorLog."Date and Time" := CurrentDateTime;
        ErrorLog.Source := CopyStr(Source, 1, MaxStrLen(ErrorLog.Source));
        ErrorLog."Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(ErrorLog."Error Message"));
        ErrorLog."Additional Info" := CopyStr(AdditionalInfo, 1, MaxStrLen(ErrorLog."Additional Info"));
        ErrorLog.Insert(true);
    end;

    /// <summary>
    /// Retrieves the most recent error message from the Error Log.
    /// </summary>
    /// <returns>The most recent error message, or an empty string if no errors are found.</returns>
    procedure GetLastError(): Text
    var
        ErrorLog: Record "Error Log";
    begin
        ErrorLog.SetCurrentKey("Date and Time");
        ErrorLog.SetAscending("Date and Time", false);
        if ErrorLog.FindFirst() then
            exit(ErrorLog."Error Message");
        exit('');
    end;
}
