//
//  ContentView.swift
//  Using SwiftUI
//
//  Created by Richard Telford on 2/1/23.
//

import SwiftUI

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
    @State private var isAlertPresented: Bool = false
    @State private var idToDelete: Int = -1
    @State private var taskNameToEdit: String = ""
    @State private var taskDescriptionToEdit: String = ""
    @State private var taskIndexToEdit: Int = -1
    
    // The following workaround allows us to create "computed" state variable bindings
    // Learn more: https://stackoverflow.com/a/59341588/2672265
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
        NavigationView {
            List {
                Toggle(isOn: $showOnlyPendingTasks) {
                    Text("Only Show Pending Tasks")
                }
                ForEach(filteredTasks) { task in
                    NavigationLink {
                        TaskDetail(task: task)
                            .environmentObject(modelData)
                    } label: {
                        ToDoListRow(task: task)
                            .environmentObject(modelData)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                          Button(role: .destructive) {
                              isAlertPresented = true
                              idToDelete = task.id
                          } label: {
                           Label("Delete", systemImage: "trash")
                          }
                          .tint(.red)
                        }
                    .alert("Are you sure?", isPresented: $isAlertPresented) {
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
                    .sheet(isPresented: bindingIsTaskEditorShown) {
                        TaskEditor(isTaskEditorShown: bindingIsTaskEditorShown, taskName: taskNameToEdit, taskDescription: taskDescriptionToEdit, taskIndex: taskIndexToEdit)
                    .environmentObject(modelData)
                    }
                }
            }
            .animation(.default, value: filteredTasks)
            .onChange(of: scenePhase) { phase in
                // Whenever the app becomes inactive, save data to persistent storage
                if phase == .inactive { saveTasks() }
            }
            .navigationTitle("ToDo List")
            .navigationBarItems(trailing: Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                        .sheet(isPresented: $showSheet) {
                            TaskEditor(isTaskEditorShown: $showSheet)
                                .environmentObject(modelData)
                        }
                }
            )
        }
    }
}


// This is why we have the live view on the right
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(saveTasks: {})
            .environmentObject(ModelData())
    }
}

