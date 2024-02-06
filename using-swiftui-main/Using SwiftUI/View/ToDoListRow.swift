//
//  ToDoListRow.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import SwiftUI

struct ToDoListRow: View {
    var task: Task
    @EnvironmentObject var modelData: ModelData
    var taskIndex: Int {
        modelData.tasks.firstIndex(where: {
            $0.id == task.id
        }) ?? 0
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                Text(task.description != "" ? task.description : "No description")
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer()
            Checkbox(isChecked: $modelData.tasks[taskIndex].isDone)
        }
    }
}

struct ToDoListRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListRow(task: ModelData().tasks[0])
            .environmentObject(ModelData())
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
