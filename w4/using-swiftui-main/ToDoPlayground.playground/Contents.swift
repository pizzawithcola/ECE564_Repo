/*:
 # SwiftUI Lesson
 ## Building a fully functional To-Do List app using SwiftUI
 *Anshu Dwibhashi (ad353) - Feb 7, 2022*
 
 SwiftUI is Apple's attempt at providing a declarative framework for creating cross-platform (cross-device, but within Apple's ecosystem only, really) apps in Swift. In the traditional Storyboard approach of creating apps, you define Views in your Storyboards, Models in Swift, and write Controllers (also in Swift) to contain the logic to act as a liaison between the two. This results in developers having to write a lot of boilerplate code, and them having to worry about implementation details which wastes a lot of time since a lot of it is repetitive.
 
 SwiftUI (like React Native and React.js for web apps) is a declarative framework, so you only have to specify what your intended end-result UI and behaviors are, and leave it to SwiftUI to worry about acting as a controller between the two. This is called the "MVVM" (Model, View, View-Model) pattern.
 
 Since there is no explicit controller, your apps' global state must exist *somewhere* (local, view-specific state can exist within your View structs), and neither individual Views nor individual Models are an appropriate location to hold your application's state. For global, app-level state management, Apple provides a framework called Combine. This is analogous to the Context system in React.
 
 We'll begin by importing necessary modules. `PlayGroundSupport` is only for us to be able to run this app in a playground.
 SwiftUI and Foundation are the only real modules our app uses.
 
 */
import SwiftUI
import Foundation

import PlaygroundSupport
/*:
 Next, we'll define our data model.
 
 First, we have to define our struct called `Task` which will hold one instance of a task.
 This struct conforms to `Codable` (so that we can encode and decode it as binary data and save it in a file).
 This struct also conforms to `Hashable` so that we can do struct equivalency checks.
 This struct also conforms to `Identifiable` so that when we create `Lists` and `ForEach` views later on, we don't have to explicitly provide an id for each `Task`. This will make more sense later in this lesson.
 
 In your SwiftUI app, this `Task` structure should be in a file of its own. In this Playground, all code is going to be contained in this one file, but a real SwiftUI app is structured differently. (You *can* have it all in your main file, but that's bad practice.) Take a look at [this repository on GitLab](https://gitlab.oit.duke.edu/ECE564/root/samplecode/todolist-swiftui) for a completed version of this app to understand how to go from a Playground file containing your entire app to a properly structured SwiftUI project.
 */
struct Task: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var isDone: Bool
    var lastModified: Date
}
/*:
 Now we'll define a class called `ModelData` which contains some variables and methods that the rest of our app can use to manipulate its model.
 
 This class conforms to the `ObservableObject` protocol from the Combine framework. This means that our `ModelData` class can hold global state information, and it contains certain fields that can be published for all consumers of that data to receive updates. Additionally, any updates made by child-Views to this state will cause SwiftUI to intelligently re-render any Views that depend on information that was updated.
 */
final class ModelData: ObservableObject {
/*:
 The first field in this class is a private static array of hardcoded `Task` structs to return when the user has opened the app for the first time and there aren't any tasks saved to disk.
 */
    private static var defaultTasks: [Task] = [
        Task(id: 0, name: "Buy eggs", description: "For breakfast tomorrow", isDone: false, lastModified: Date.now),
        Task(id: 1, name: "Buy milk", description: "By this weekend", isDone: true, lastModified: Date.now),
        Task(id: 2, name: "Take the dog to the vet", description: "This is a very long description just to show that task descriptions are potentially long sentences or even paragraphs. The list on the home screen will show a truncated version of the description but the detail view will show you the entire description.", isDone: false, lastModified: Date.now),
        Task(id: 3, name: "Finish ECE 564 homework", description: "Hmm...", isDone: false, lastModified: Date.now),
        Task(id: 4, name: "Think of more tasks for this demo", description: "", isDone: false, lastModified: Date.now),
        Task(id: 5, name: "Go for a walk", description: "It's good for you!", isDone: false, lastModified: Date.now),
        Task(id: 6, name: "Eat five portions of vegetables a day", description: "It's good for you!", isDone: true, lastModified: Date.now),
        Task(id: 7, name: "Learn SwiftUI", description: "", isDone: true, lastModified: Date.now),
        Task(id: 8, name: "Refactor this codebase", description: "Before students get their hands on it", isDone: false, lastModified: Date.now),
        Task(id: 9, name: "Add guiding comments to this codebase", description: "Before students get their hands on it", isDone: true, lastModified: Date.now)
    ]
/*:
 The `@Published` attribute below tells SwiftUI to publish any changes to this field to all subscribers that depend on its value.
 */
    @Published var tasks: [Task] = defaultTasks
/*:
 The following private, static function returns the URL of the file on disk that our app uses to store its state to persist across app sessions. We won't go into details of persistent storage since the focus of this lesson is SwiftUI, but see [this lesson](https://developer.apple.com/tutorials/app-dev-training/persisting-data) by Apple for more information on persistent storage in SwiftUI apps.
 
 The two functions that follow are for loading data from this file into our `tasks` array, and for storing our dynamic `tasks` array to disk. Again, they have no code that's specific to SwiftUI, so review the lesson on persistent storage to understand what's going on here.
 */
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
                    .appendingPathComponent("tasks.data")
    }
    
    static func load(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(defaultTasks))
                    }
                    return
                }
                
                let loadedTasks = try JSONDecoder().decode([Task].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedTasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(tasks: [Task], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(tasks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(tasks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
/*:
 This part is optional if you're satisfied with the built-in switch-like `Toggle` control in SwiftUI. I wanted a check-box-like control for my to-do list, so I made a custom View as you can see below. Even if constructing your own View is optional here, the code below illustrates an important concept in SwiftUI called *binding*.
 
 A *binding* allows for two-way modifications to a variable. A parent view can pass a "binding to a variable" to a child view, and any modifications that the child makes to the binding will be reflected in the original variable that is in the parent. (Think of this *loosely* like pointers in C/C++, but this is a bit more high-level than that. Swift does have real pointers too, and this isn't it.)
 
 To declare a binding in a child view, use the `@Binding` attribute like in the case of the `isChecked` field in `Checkbox` below. A parent view containing an instance of `Checkbox` will contain a boolean field, and pass a binding to this field to `Checkbox`. Then, when a tap on the checkbox causes the `Checkbox` struct to modify the value of `isChecked`, the binding will cause the parent view's boolean field's value to be updated as well.
 
 This system of bindings is analogous to props in React Native and React.js.
 */
struct Checkbox: View {
    @Binding var isChecked: Bool
    var body: some View {
/*:
 What you see below is a use of *modifiers*. Line 130 returns an `Image` struct initialized with a string passed in as `systemName`. When we call `resizable` on that returned result, that function returns yet another instance of `Instance` which is now resizable. Such functions which are members of structs and return copies of the struct with modifications made are called *modifiers*. This allows us to chain multiple calls to modifiers as you can see on lines 131-136.
 */
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
            .foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture { // Review trailing closure syntax if this looks confusing to you!
                isChecked.toggle()
            }
    }
}
/*:
 The first UI component we're going to build is a View containing a single row of our to-do list table (which is the main View in our app).
 
 To declare a View in SwiftUI, create a struct that conforms to the `View` protocol.
 */
struct ToDoListRow: View {
    var task: Task // The task object that this row will depict
/*:
 Remember we said we're going to make our `ModelData` class conform to `ObservableObject` so that we can store global state in it, and so that children views can subscribe to any changes in that state? The following line shows you how to do it. You declare a variable of the type `ModelData` and mark it with an `@EnvironmentObject` attribute. A parent view will pass global state to this view using the `.environmentObject` modifier and any changes we make to variables contained in global state will be propagated to all other subscribers. This will also cause a re-render of any views that depend on information that a child view changes.
 */
    @EnvironmentObject var modelData: ModelData
    
    // A computed property computing the index of this task in the array contained in ModelData
    // We'll use this to modify the global tasks array contained in our global state
    var taskIndex: Int {
        modelData.tasks.firstIndex(where: {
            $0.id == task.id
        }) ?? 0
    }
/*:
 To conform to the `View` protocol, a struct must define a computed property called `body` of the `View` type.
 The `some` keyword may be a bit confusing (and isn't super important to be able to use SwiftUI) but think of it as a "reverse generic placeholder." See [this page](https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html#ID614) on Swift's website for more information.
 */
    var body: some View {
        // HStack allows us to group multiple Views in a horizontal fashion and return a single parent View called HStack
        HStack {
            // VStack allows us to group multiple Views in a vertical fashion and return a single parent View called VStack
            VStack(alignment: .leading) {
/*:
 What you see below is fancy syntactical sugar called `ViewBuilder` syntax. (Learn more [here](https://developer.apple.com/documentation/swiftui/viewbuilder).) This allows us to simply define `Text` after `Text` (or any View after any other View) and the parent (VStack in this case) will understand that all such Views defined within the braces are its children. A `ViewBuilder` is technically a closure.
 
 Views like VStack (and HStack) accept a [closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html) defining Views that will be contained within this parent. However, instead of having one return statement, `ViewBuilder` closures are closures that just contain a bunch of statements, all of which are declarations of Views. All these Views are the contained in the parent View. This is effectively almost like returning an array of Views that the parent will treat as children, but we're not actually returning an array.
 */
                Text(task.name)
                    .font(.headline)
                Text(task.description != "" ? task.description : "No description")
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer() // Expands to consume all remaining space and push the previous and next Views to the edges.
/*:
 On the following line, we see bindings in action. This `ToDoListRow` struct is a parent view containing a child `Checkbox` as defined on the following line. We pass a binding to a boolean `modelData.tasks[taskIndex].isDone` to `Checkbox` so any changes made by `Checkbox` to its binding will be propagated back to `modelData.tasks[taskIndex].isDone`. To specify that you're passing a binding to a variable and not the variable itself, use the `$` symbol.
 */
            Checkbox(isChecked: $modelData.tasks[taskIndex].isDone)
        }
    }
}
/*:
 Now we'll define a detail view for our tasks. When a user taps on a task in the main screen's list view, they'll be taken to this view.
 */
struct TaskDetail: View {
/*:
 To access certain properties from the environment, we can use the `Environment` property-wrapper struct. To access a property of the view's environment, you can use the `@Environment` attribute as follows: `@Environment(\.propertyName` will extract the property whose name is "propertyName" from the `Environment` and make it available to the declaration that follows.
 
 Unlike an `EnvironmentObject`, a parent view isn't required to pass this child view anything. The environment variables are available via the `Environment` property wrapper to the view automatically.
 
 In the following line, we extract the `presentationMode` property from the environment and declare a variable called `presentationMode` to contain it. This property happens to be a `Binding` to a `PresentationMode` type.
 
 We'll use this variable later in this struct.
 */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var modelData: ModelData // This is explained above (under ToDoListRow)
    var task: Task
    private var taskIndex: Int {
        modelData.tasks.firstIndex(where: {
            $0.id == task.id
        }) ?? 0
    }
/*:
 The following lines demonstrate state variables. We declare a variable like we normally would in a struct, but use the `@State` attribute to indicate that it holds a part of our View's state. (This is analogous to the `useState` hook in React, if you're familiar with React.js.)
 
 Now, if any code in this struct modifies these state variables, any subviews that depend on those variables' values will be re-rendered without any effort on the programmer's part. Bindings to state variables can be passed to children just like with normal variables.
 
 One caveat is that you can't mark a computed property as a `@State` property, but if you want to make use of the automatic re-rendering of child views for computed properties, there are workarounds we'll look at later in this playground.
 */
    @State var isAlertPresented: Bool = false
    @State var isTaskEditorShown: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .top) {
                VStack (alignment: .leading) {
                    Text(task.name)
                        .font(.title)
                    Text(task.description != "" ? task.description : "No description")
                        .font(.headline)
                }
                Spacer()
                Checkbox(isChecked: $modelData.tasks[taskIndex].isDone)
            }
            Text("Last modified on \(task.lastModified)")
                .foregroundColor(.secondary)
            Spacer()
            HStack {
                Spacer()
/*:
 Here's one way to instantiate a Button.
 
 The first parameter named `action` is a closure defining the action that will be executed if the button is pressed. The second unnamed parameter is a closure that defines a View that will act as the button's label. Since both parameters are trailing closures, no parentheses are required, but this is equivalent to making a `Button` instance like this:
 ```
 Button(action: { isTaskEditorShown = true }, label: { Text("Edit") })
 ```
 Recall that when a function accepts multiple trailing closure, you can leave one of them unnamed and Swift will infer what parameter that closure corresponds to. In the following lines, I didn't have to label the second closure as `label`.
 */
                Button(action: {
                    isAlertPresented = true // This changes a state variable and causes the alert below to be rendered
                }) {
                    Text("Delete Task")
                }
                .alert("Are you sure?", isPresented: $isAlertPresented) {
/*:
 Here's another way of defining a Button.
 Pass a string (to display as the button's label) as an argument and a trailing closure to execute code when the button is pressed.
*/
                    Button("Yes") {
                        isAlertPresented = false
                        presentationMode.wrappedValue.dismiss() // Here's why we needed to extract presentationMode from the environment; this is how you dismiss your modal in SwiftUI
                        modelData.tasks.remove(at: taskIndex)
                    }
                    Button("No") {
                        isAlertPresented = false
                    }
                }
                .tint(.red)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Task Details") // What the "title" of this "screen" (View, really) will be
        .navigationBarTitleDisplayMode(.inline) // Tells iOS to show this title in a bar on top and not like a big heading (like on the main screen)
/*:
 Here's another way to instantiate a Button (on line 253, passed to `navigationBarItems` as an argument called `trailing`).
 
 The first (unnamed) parameter is a closure defining the action that will be executed if the button is pressed. The second parameter is a closure named `label` and defines a View that will act as the button's label. Since both parameters are trailing closures, no parentheses are required, but this is equivalent to making a `Button` instance like this:
 ```
 Button(action: { isTaskEditorShown = true }, label: { Text("Edit") })
 ```
 */
        .navigationBarItems(trailing: Button {
                isTaskEditorShown = true
            }
            label: {
                Text("Edit")
            }
            .sheet(isPresented: $isTaskEditorShown) {
                TaskEditor(isTaskEditorShown: $isTaskEditorShown, taskName: task.name, taskDescription: task.description, taskIndex: taskIndex)
                    .environmentObject(modelData) // Here's an example of a parent view passing a global state object to a child view using the environmentObject modifier
            }
        )
    }
}
/*:
 Now we'll define a view for creating and updating tasks.
 */
struct TaskEditor: View {
    @Binding var isTaskEditorShown: Bool
    @State var taskName: String = ""
    @State var taskDescription: String = ""
    @State var isAlertPresented: Bool = false
    @EnvironmentObject var modelData: ModelData
    var taskIndex = -1 // -1 means new task
/*:
 Everything in this class up to this point should make sense since we've discussed all these attributes before. We wrap our `Form` in a `NavigationView` so that we can add a custom navigation bar title and buttons for this view (which is displayed as a modal or a sheet). We didn't have to do this for our `TaskDetail` view because it's displayed as a new page in a traditional "push" navigation controller, so it shares a navigation bar with our main parent view (defined later in this playground).
 */
    var body: some View {
        NavigationView {
            Form {
                TextField(text: $taskName, prompt: Text("What's your task?"), label: {() in Text("What's your task?")})
                Text("Notes:")
                TextEditor(text: $taskDescription)
                    .frame(width: 300, height: 100, alignment: .leading)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.gray)
            .navigationTitle(taskIndex == -1 ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button {
                isTaskEditorShown = false
                } label: {
                    Label("Cancel", systemImage: "chevron.left")
                        .labelStyle(.titleOnly)
                }
            )
            .navigationBarItems(trailing: Button {
                    guard taskName.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                        isAlertPresented = true
                        return
                    }
                    
                    if taskIndex == -1 {
                        modelData.tasks.append(Task(id: (modelData.tasks.last?.id ?? 0) + 1, name: taskName, description: taskDescription, isDone: false, lastModified: Date.now))
                    } else {
                        modelData.tasks[taskIndex].name = taskName
                        modelData.tasks[taskIndex].description = taskDescription
                        modelData.tasks[taskIndex].lastModified = Date.now
                    }
                    isTaskEditorShown = false
                } label: {
                    Label("Save", systemImage: "chevron.left")
                        .labelStyle(.titleOnly)
                }
                    .alert("Task title is required", isPresented: $isAlertPresented) {
                    Button("OK") {
                        isAlertPresented = false
                    }
                }
            )
        }
    }
}
/*:
 Our `ContentView` struct contains all the content of our app in one view and will be the root view of our app. This is the root view that we wrap in a `NavigationView` to implement navigation as we'll discuss in the following section.
 */
struct ContentView: View {
    // Monitor scene phase to see if the app is inactive; if so, we'll save our model to disk.
    @Environment(\.scenePhase) private var scenePhase
    
    // Function to perform when app is inactive (defined by parent)
    let saveTasks: () -> Void
    
    @EnvironmentObject var modelData: ModelData
    @State private var showOnlyPendingTasks = false

    var filteredTasks: [Task] {
        modelData.tasks.filter {
            !$0.isDone || !showOnlyPendingTasks
        }
    }
    
    @State private var showSheet = false
    @State var isAlertPresented: Bool = false
    @State var idToDelete: Int = -1
    @State var taskNameToEdit: String = ""
    @State var taskDescriptionToEdit: String = ""
    @State var taskIndexToEdit: Int = -1
/*:
 Remember we talked about a workaround for not being able to use `@State` for computed properties? Here it is. We create a new binding-type property, whose getter is computed from other properties. Now instead of passing a binding to a state variable, we can directly pass this variable (which is of a binding type) to a child view to control.
 
 If SwiftUI allowed us to use `@State` with computed properties, lines 389-397 would simply look like this:
 
 ```
 @State var isTaskEditorShown: Bool {
    taskNameToEdit != "" && taskIndexToEdit != -1
 }
 ```
 
 And later, we could've passed a binding to this state variable like `$isTaskEditorShown`. Unfortunately, since we can't have computed state properties, we have to use this workaround.
 */
    private var bindingIsTaskEditorShown: Binding<Bool> { Binding (
        get: { taskNameToEdit != "" && taskIndexToEdit != -1 },
        set: { _ in
                taskNameToEdit = ""
                taskIndexToEdit = -1
                taskDescriptionToEdit = ""
            }
        )
    }
    
    var body: some View {
/*:
 Now we'll look at how navigation is implemented in SwiftUI. Wrap your top-level view (`List` in this case) in a `NavigationView`. A `List` can either be static (simply define all your rows' views one by one using `ViewBuilder` syntax in the braces that follow `List`), or dynamic (simply pass your collection of row data objects to `List` and also pass a closure to return a view for each row element like `List(data) { item in MyItemView(...) }`), or a hybrid of static and dynamic rows as in the case below.
 
 The first row in our list is a static `Toggle` View. Therefore, the first view in the closure passed to `List` is a `Toggle`. Now we want the remaining views to be dynamically generated, so we use the `ForEach` view. This view takes in an array (or some other collection) of data objects, and calls a function (passed as a trailing closure) with each element in the collection. This function returns a view that will correspond to a row in the list.
 */
        NavigationView {
            List {
                Toggle(isOn: $showOnlyPendingTasks) {
                    Text("Only Show Pending Tasks")
                }
                ForEach(filteredTasks) { task in
/*:
 We want to render a `ToDoListRow` for each `task` object. However, we can't just render a raw `ToDoListRow` because we'd like the user to be taken to a `TaskDetail` view corresponding to this task when they click this row. So, we'll wrap this in a `NavigationLink`. The first (unnamed) argument to `NavigationLink` is a trailing closure that defines the destination View. The second argument named `label` defines the View that will be rendered here, which when clicked, will take the user to the destination mentioned previously.
 */
                    NavigationLink {
                        TaskDetail(task: task)
                            .environmentObject(modelData)
                    } label: {
                        ToDoListRow(task: task)
                            .environmentObject(modelData)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) { // Adding swipe actions to list rows is as simple as calling the swipeActions modifier function on the View that corresponds to your row
                          Button(role: .destructive) {
                              isAlertPresented = true
                              idToDelete = task.id
                          } label: {
                           Label("Delete", systemImage: "trash")
                          }
                          .tint(.red)
                        }
                    .alert("Are you sure?", isPresented: $isAlertPresented) { // This is how you show alerts in SwiftUI; you use a modifier. It's only shown if the isPresented binding is true
                        Button("Yes") {
                            withAnimation { modelData.tasks.removeAll(where: { $0.id == idToDelete })
                            }
                            idToDelete = -1
                        }
                        Button("No") { idToDelete = -1 }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                          Button {
                              taskIndexToEdit = modelData.tasks.firstIndex(where: { $0.id == task.id })!
                              taskNameToEdit = task.name
                              taskDescriptionToEdit = task.description
                          } label: {
                            Text("Edit")
                          }
                          .tint(.blue)
                        }
                    .sheet(isPresented: bindingIsTaskEditorShown) { // This is how we show a new view in a modal instead of navigating to it using a "push" navigation controller (which is what NavigationLink does)
                        TaskEditor(isTaskEditorShown: bindingIsTaskEditorShown, taskName: taskNameToEdit, taskDescription: taskDescriptionToEdit, taskIndex: taskIndexToEdit)
                            .environmentObject(modelData)
                    }
                }
            }
            .animation(.default, value: filteredTasks) // This is how we animate the list when its contents are changed
            .onChange(of: scenePhase) { oldValue, newValue in
                // Whenever the app becomes inactive, save data to persistent storage
                if newValue == .inactive { saveTasks() }
            }
            .navigationTitle("ToDo List")
            .navigationBarItems(trailing: Button { // This is actually a deprecated way of adding bar button items, but this results in a different looking UI than the newer recommended approach (I like this one better)
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                        .sheet(isPresented: $showSheet) {
                            TaskEditor(isTaskEditorShown: $showSheet)
                                .environmentObject(modelData)
                        }
                }
            )
            
/*:
 The following is the "recommended" way to add a navigation bar item, but for some reason it looks worse the older and deprecated way above, even though it's functionally equivalent:
 
 ```
 .toolbar {
     ToolbarItem(placement: .navigationBarTrailing) {
         Button {
                 showSheet = true
             } label: {
                 Image(systemName: "plus")
                     .sheet(isPresented: $showSheet) {
                         TaskEditor()
                     }
             }
     }
 }
 ```
 */
        }
    }
}
/*:
 The following lines of code are only for creating an instance of `ContentView` and running it live in our playground. In a real SwiftUI app, your global `ModelData` state will be defined in your main `App` class as a `@StateObject`. We'll talk more about this after the playground code below.
 */
var modelData = ModelData()
let contentView = ContentView(saveTasks: {
        ModelData.save(tasks: modelData.tasks) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    })
        .environmentObject(modelData)
        .onAppear {
            ModelData.load { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .success(let tasks):
                    modelData.tasks = tasks
                }
            }
        }

PlaygroundPage.current.setLiveView(contentView)
/*:
 
 Here's how your top-level file will look in a real SwiftUI app.
 
 Your top-level struct should conform to the `App` protocol, and is the starting point of your application.
 
 The @main annotation tells the system that this is the file that is the entry point into your app. You instantiate your global state as a `ModelData` variable in your main app class, and mark it with a `@StateObject` attribute. A `@StateObject` attribute is like a `@State` attribute (so any changes made to this variable will cause appropriate child views to be re-rendered) but specifically for properties that are instances of `ObservableObjects` like `ModelData`. This is the difference between global, app-level state and local, view-level state.
 
 The body of a struct conforming to `App` should be a computed property that returns some `Scene` which wraps your main `ContentView` within a `WindowGroup`. `WindowGroup` will have only one View as a child in iOS apps. It can have multiple Views (to be rendered as multiple windows) in macOS apps.
 ```
 @main
 struct ToDoApp: App {
     @StateObject private var modelData = ModelData()
     var body: some Scene {
         WindowGroup {
             ContentView(saveTasks: {
                 ModelData.save(tasks: modelData.tasks) { result in
                     if case .failure(let error) = result {
                         fatalError(error.localizedDescription)
                     }
                 }
             })
                 .environmentObject(modelData)
                 .onAppear {
                     ModelData.load { result in
                         switch result {
                         case .failure(let error):
                             fatalError(error.localizedDescription)
                         case .success(let tasks):
                             modelData.tasks = tasks
                         }
                     }
                 }
         }
     }
 }

 ```
 
 */
