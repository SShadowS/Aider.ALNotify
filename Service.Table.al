/// <summary>
/// Table 50101 "Service".
/// Stores information about services that can generate notifications.
/// </summary>
table 50101 "Service"
{
    DataClassification = CustomerContent;
    
    fields
    {
        /// <summary>
        /// The unique identifier for the service.
        /// </summary>
        field(1; "Service ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        /// <summary>
        /// The name of the service.
        /// </summary>
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Service ID")
        {
            Clustered = true;
        }
        key(Name; Name)
        {
            Unique = true;
        }
    }
}
