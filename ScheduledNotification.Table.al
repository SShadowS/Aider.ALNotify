/// <summary>
/// Table 50116 "Scheduled Notification".
/// Stores information about notifications that are scheduled to be sent at a later time.
/// </summary>
table 50116 "Scheduled Notification"
{
    DataClassification = CustomerContent;
    
    fields
    {
        /// <summary>
        /// The unique identifier for the scheduled notification.
        /// </summary>
        field(1; "Scheduled ID"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        /// <summary>
        /// The ID of the associated notification.
        /// </summary>
        field(2; "Notification ID"; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = Notification."Notification ID";
        }
        /// <summary>
        /// The date and time when the notification is scheduled to be sent.
        /// </summary>
        field(3; "Scheduled At"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        /// <summary>
        /// The recurrence pattern for the scheduled notification.
        /// </summary>
        field(4; Recurrence; Enum "Notification Recurrence")
        {
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Scheduled ID")
        {
            Clustered = true;
        }
    }
}
