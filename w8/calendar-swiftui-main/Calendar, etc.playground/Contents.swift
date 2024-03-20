import UIKit
import SwiftUI
/*:
 # Calendar, etc. in SwiftUI
   - Note:
 The bulk of this repo comes from the the downloaded source code example [here.](https://developer.apple.com/documentation/eventkit/accessing_calendar_using_eventkit_and_eventkitui) The code should be handled per the Apple LICENSE included in the repository.  The repo is interesting in that it can produce 3 different apps depending on which Scheme you choose.  If your preview is not working, make sure the right Scheme is selected.
 */
/*:
   - Note:
The code in this reposoitory is just the Apple SwiftUI code.  To see more about using Calendar and Contacts in UIKit, see the "Maps_etc." repository.
 */
/*:
## Calendar.app and interfaces
*   Calendar.app is a database of calendar events, but also includes Reminder objects
     * Import `EventKit` for framework access
     * Import `EventKitUI` for UI object access
*   The Calendar DB is an instance of the `EKEventStore` class.
*   Three key objects in the database:
     * Calendars  -  `EKCalendar`
     * Calendar  items  -  `EKCalendarItem`
     * Reminders  - `EKReminder`
*   The pre-built VCs / UI consist of:
     * `EKEventViewController` – shows the description of a single event
     * `EKEventEditViewController` – allows the user to create or edit event
     * `EKCalendarChooser` – allows the user to pick a calendar
 */
/*:
 ## Contacts.app and interfaces
 *   Contacts.app is a database that can accessed through the UI or the Contacts framework.
     * Import `Contacts` for the framework APIs
     * Import `ContactsUI` for the UI
 *   Key object types:
     * `CNContactStore` – the user’s database
     * `CNContact` – an individual contact
 *    Database is searched using predicates and keysToFetch
 *    Saving a new contact involves using a `CNContactSave` object
 *    The Contacts UI consists of:
      * `CNContactPickerViewController`
      * `CNContactViewController`
 */
/*:
 ##  Key Concept for SwiftUI:  UIViewControllerRepresentable
 * `UIViewControllerRepresentable` is the key protocol for interfacing UIViewControllers with SwiftUI
 * The Protocol requires that you implement `makeUIViewController` method and an `updateUIViewController` method
 * The `make` method creates the view controller object and configures its initial state
 * The `update` method updates the state of the specified view controller with new information from SwiftUI
 * It also requires a `makeCoordinator` method call to set up a `Coordinator` object (generally `self`)
 *  The `make` method creates a custom instance of a coordinator object that you use to communicate changes from your view controller to other parts of your SwiftUI interface.
 *  Your Coordinator will contain the logic for delegate methods, passing back variable information, etc.
 */
