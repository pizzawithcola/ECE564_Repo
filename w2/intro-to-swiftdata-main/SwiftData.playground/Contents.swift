import SwiftData
// This information is from Apple WWDC 2023
/*:
 ## SwiftData - a quick overview
 As Apple says "SwiftData is a powerful framework for data modeling and management".  What do you think that means?
 
 Highlights:
 * The usage of **Macros** - "Swift macros help you avoid writing repetitive code in Swift by generating that part of your source code at compile time. Calling a macro is always additive." (from developer.apple.com documentation)
 * Seamless integration with SwiftUI (but can be used outside of SwiftUI)
 * Integrates with Core Data and CloudKit
 
 Let's first look at the macro `@Model`
 ### `@Model`
 * `@Model` is a new Swift macro that helps to define your model's schema from your Swift code.
 * SwiftData schemas are normal Swift code, but allows you to add metadata to your properties as well
 * Once you add `@Model`, a data schema is generated
 * The immediate benefit is now your stored properties become persisted properties
 ````
 @Model
 class Trip {
    var name: String
    var destination: String
    var endDate: Date
    var startDate: Date
 
    var bucketList: [BucketListItem]? = []
    var livingAccommodation: LivingAccommodation?
 }
 ````
 * There are additional macros which act as metadata for your properties, such as `@Attribute` and `@Relationship`
 #### @Attribute
 * Specifies the custom behavior that SwiftData applies to the annotated property when managing the owning class.
 * The most common @Attribute is .unique, which ensures the property’s value is unique across all models of the same type.
 * Other values are .ephemeral, .externalStorage, .spotlight
 #### @Relationship
 * An object that describes the configuration and behavior of a relationship between two model classes
 * For example, the enum Relationship.DeleteRule has options which describe the rule to apply when deleting a model containing references to other models (such as .cascade - A rule that deletes any related models.)
 ````
 @Model
 class Trip {
    @Attribute(.unique) var name: String  // ensure the name of this Trip is unique in the data model
    var destination: String
    var endDate: Date
    var startDate: Date
 
    @Relationship(.cascade) var bucketList: [BucketListItem]? = []  // delete all bucketList items when the Trip is deleted
    var livingAccommodation: LivingAccommodation?
 }
 ````
 ### Persistence with ModelContainer and ModelContext
 #### ModelContainer
 * Provides the persistent container for your @Models
 * You create a model container by listing the @Models you want stored.
 * By specifying a URL, or using CloudKit, you can specify how / where you want your Container created
 * See the App swift file in this project for how to initialize in SwiftUI
 
 ModelContainer instance outside of SwiftUI:
 Initialize with only a schema
 
 ````
 let container = try ModelContainer([Trip.self, LivingAccommodation.self])
 ````
 
 Initialize with configurations
 ````
 let container = try ModelContainer(
 for: [Trip.self, LivingAccommodation.self],
 configurations: ModelConfiguration(url: URL("path"))
 )
 ````
 ModelContainer instance inside of SwiftUI:
 ````
 import SwiftUI
 
 @main
 struct TripsApp: App {
    var body: some Scene {
        WindowGroup {
        ContentView()
    }
    .modelContainer(
        for: [Trip.self, LivingAccommodation.self]
    )
    }
 }
 ````
 #### ModelContext
 * Observes all the changes to your @Models and takes action as needed
 * It is the interface for interacting with your data, especially from SwiftUI
 * You get the model context from the environment pool once a ModelContainer has been defined
 * See the ContextView for an example
 ### @Query
 * Once you have your model data, the best way to start working with it is by using `@Query`
 * @Query will load your data, either all of it or with some type of filters.
 * Think of it like a true database query - you can give it parameters to refine the way you want the data retrieved, filtered, sorted, etc.
 ````
 struct ContentView: View  {
 @Query(sort: \.startDate, order: .reverse) var trips: [Trip]
 @Environment(\.modelContext) var modelContext
 
 var body: some View {
    NavigationStack() {
        List {
            ForEach(trips) { trip in
            // ...
                }
            }
        }
     }
 }
 ````
 */
