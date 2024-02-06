//
//  TaskEditor.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import SwiftUI

struct TaskEditor: View {
    @Binding var isTaskEditorShown: Bool
    @State var taskName: String = ""
    @State var taskDescription: String = ""
    @State var isAlertPresented: Bool = false
    @EnvironmentObject var modelData: ModelData
    var taskIndex = -1 // -1 means new task
    
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

struct TaskEditor_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditor(isTaskEditorShown: .constant(true))
            .environmentObject(ModelData())
    }
}
