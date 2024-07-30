# Aider.ALNotify
I wanted to test of Aiders capabilities in AL programming. This repo is the result of that test. The description of the project is given below.

Technologies:
- Aider [https://github.com/paul-gauthier/aider]
- ChatGPT-4o (Description)
- Claude 3.5 Sonnet (Aider)

This is the description given to Aider and it was originally written by ChatGPT-4o:
```markdown
Extended Notification Framework for Business Central (AL)

This framework is designed to handle notifications in Business Central, supporting multiple protocols, templates, events, and archiving capabilities. It accommodates different users and services, with enhanced features for user preferences, rich content, localization, and analytics.

Main Entities and Their Fields:

1. User:
   - user_id (integer, primary key)
   - username (varchar, unique)
   - email (varchar, unique)

2. Service:
   - service_id (integer, primary key)
   - name (varchar, unique)

3. Protocol:
   - protocol_id (integer, primary key)
   - name (varchar, unique)
   - endpoint (varchar, nullable)

4. Template:
   - template_id (integer, primary key)
   - name (varchar)
   - content (text)
   - protocol_id (integer, foreign key to Protocol)
   - service_id (integer, foreign key to Service)
   - content_type (enum: text, html, markdown)
   - attachments (json) # Store file paths or URLs
   - dynamic_fields (json) # Store field names and their data sources

5. Event:
   - event_id (integer, primary key)
   - name (varchar, unique)
   - description (text, nullable)

6. Notification:
   - notification_id (integer, primary key)
   - title (varchar)
   - message (text)
   - protocol_id (integer, foreign key to Protocol)
   - created_at (timestamp)
   - sent_at (timestamp, nullable)
   - user_id (integer, foreign key to User)
   - service_id (integer, foreign key to Service)
   - template_id (integer, foreign key to Template)
   - status (enum: pending, sent, failed, canceled)

7. Archive:
   - archive_id (integer, primary key)
   - notification_id (integer, foreign key to Notification)
   - protocol_id (integer, foreign key to Protocol)
   - sent_at (timestamp)

8. NotificationEvent:
   - notification_event_id (integer, primary key)
   - notification_id (integer, foreign key to Notification)
   - event_id (integer, foreign key to Event)

9. Pushbullet:
   - pushbullet_id (integer, primary key)
   - access_token (varchar)
   - device_iden (varchar, nullable)
   - email (varchar, nullable)
   - channel_tag (varchar, nullable)
   - protocol_id (integer, foreign key to Protocol)

10. Teams:
    - teams_id (integer, primary key)
    - webhook_url (varchar)
    - protocol_id (integer, foreign key to Protocol)

11. UserPreference:
    - preference_id (integer, primary key)
    - user_id (integer, foreign key to User)
    - event_id (integer, foreign key to Event)
    - protocol_id (integer, foreign key to Protocol)
    - is_enabled (boolean)
    - frequency (enum: immediate, daily, weekly)

12. NotificationRetry:
    - retry_id (integer, primary key)
    - notification_id (integer, foreign key to Notification)
    - retry_count (integer)
    - next_retry_at (timestamp)
    - last_error (text)

13. NotificationGroup:
    - group_id (integer, primary key)
    - name (varchar)
    - description (text)

14. NotificationGroupMembership:
    - membership_id (integer, primary key)
    - group_id (integer, foreign key to NotificationGroup)
    - notification_id (integer, foreign key to Notification)

15. TemplateLocalization:
    - localization_id (integer, primary key)
    - template_id (integer, foreign key to Template)
    - language_code (varchar)
    - localized_content (text)

16. UserRateLimit:
    - rate_limit_id (integer, primary key)
    - user_id (integer, foreign key to User)
    - protocol_id (integer, foreign key to Protocol)
    - max_notifications (integer)
    - time_window (interval)
    - current_count (integer)
    - last_reset (timestamp)

17. ScheduledNotification:
    - scheduled_id (integer, primary key)
    - notification_id (integer, foreign key to Notification)
    - scheduled_at (timestamp)
    - recurrence (enum: none, daily, weekly, monthly)

18. NotificationAnalytics:
    - analytics_id (integer, primary key)
    - notification_id (integer, foreign key to Notification)
    - delivered_at (timestamp)
    - opened_at (timestamp)
    - clicked_at (timestamp)

19. Role:
    - role_id (integer, primary key)
    - name (varchar)

20. UserRole:
    - user_role_id (integer, primary key)
    - user_id (integer, foreign key to User)
    - role_id (integer, foreign key to Role)

21. RolePermission:
    - permission_id (integer, primary key)
    - role_id (integer, foreign key to Role)
    - event_id (integer, foreign key to Event)
    - can_send (boolean)

Data Flow and Functionality:

1. Event Triggering:
   - An event occurs in the system.
   - The event is recorded in the Event table.

2. Notification Selection:
   - The event triggers a query to the NotificationEvent table to find associated notification_ids.
   - Corresponding notifications are retrieved from the Notification table.

3. User Preference Check:
   - Check UserPreference table to determine if the user has enabled notifications for this event and protocol.
   - Apply user-defined frequency settings (immediate, daily, weekly).

4. Template and User Information:
   - Retrieve Template, User, and Service information based on foreign keys.
   - Use TemplateLocalization to get localized content if available.
   - Populate the notification's message field using the template content, applying dynamic fields if any.

5. Rate Limiting:
   - Check UserRateLimit to ensure the user hasn't exceeded their notification limit.
   - Update current_count and last_reset as needed.

6. Sending Notification:
   - Determine the sending method using Protocol information (e.g., Pushbullet or Teams).
   - Gather protocol-specific details from Pushbullet or Teams tables.
   - Send the notification using the appropriate protocol.
   - Update the Notification status to 'sent' or 'failed'.

7. Retry Mechanism:
   - If sending fails, create an entry in NotificationRetry.
   - Implement a background job to retry failed notifications based on retry_count and next_retry_at.

8. Archiving:
   - Once sent successfully, record the notification in the Archive table with the sent_at timestamp.

9. Analytics:
   - Create an entry in NotificationAnalytics when the notification is delivered.
   - Update opened_at and clicked_at when the user interacts with the notification (if possible with the chosen protocol).

10. Scheduled Notifications:
    - For scheduled notifications, use the ScheduledNotification table to determine when to send.
    - Implement a background job to check for due scheduled notifications and process them.

11. Notification Groups:
    - Use NotificationGroup and NotificationGroupMembership for bulk operations on related notifications.

12. Role-based Permissions:
    - Before sending notifications, check RolePermission to ensure the user has the right to send notifications for the given event.

Implementation Considerations for AL in Business Central:

1. Use AL table objects to create the database structure.
2. Implement codeunits for the main functionality (e.g., sending notifications, handling retries, scheduling).
3. Use AL page objects to create user interfaces for managing notifications, templates, and user preferences.
4. Implement background jobs using AL task scheduler for retry mechanisms and scheduled notifications.
5. Use AL enum types for fields like status, frequency, content_type and other relevant fields.
6. Implement proper error handling and logging throughout the system.
7. Use AL's built-in functions for JSON handling when dealing with attachments and dynamic fields.
8. Implement proper data validation and sanitization, especially for user inputs and dynamic content.
9. Use Interfaces for things like Protocols and so on.

This extended framework provides a robust and flexible system for handling notifications in Business Central. It addresses various aspects such as user preferences, localization, rich content, analytics, and role-based permissions, making it suitable for a wide range of business scenarios.
```