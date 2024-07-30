/// <summary>
/// Table 50109 "Teams".
/// Stores configuration information for Microsoft Teams notifications.
/// </summary>
table 50109 "Teams"
{
    DataClassification = CustomerContent;
    
    fields
    {
        /// <summary>
        /// The unique identifier for the Teams configuration.
        /// </summary>
        field(1; "Teams ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        /// <summary>
        /// The webhook URL for sending notifications to Teams.
        /// </summary>
        field(2; "Webhook URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        /// <summary>
        /// The ID of the associated protocol.
        /// </summary>
        field(3; "Protocol ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Protocol."Protocol ID";
        }
    }
    
    keys
    {
        key(PK; "Teams ID")
        {
            Clustered = true;
        }
    }
}
