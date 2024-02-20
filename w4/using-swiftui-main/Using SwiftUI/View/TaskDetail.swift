//
//  TaskDetail.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import SwiftUI

struct TaskDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var modelData: ModelData
    var task: Task
    private var taskIndex: Int {
        modelData.tasks.firstIndex(where: {
            $0.id == task.id
        }) ?? 0
    }
    
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
                Button(action: {
                    isAlertPresented = true
                }) {
                    Text("Delete Task")
                }
                .alert("Are you sure?", isPresented: $isAlertPresented) {
                    Button("Yes") {
                        isAlertPresented = false
                        presentationMode.wrappedValue.dismiss()
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
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button {
                isTaskEditorShown = true
            }
            label: {
                Text("Edit")
            }
            .sheet(isPresented: $isTaskEditorShown) {
                TaskEditor(isTaskEditorShown: $isTaskEditorShown, taskName: task.name, taskDescription: task.description, taskIndex: taskIndex)
                    .environmentObject(modelData)
            }
        )
    }
}

struct TaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetail(task: ModelData().tasks[0])
            .environmentObject(ModelData())
    }
}
