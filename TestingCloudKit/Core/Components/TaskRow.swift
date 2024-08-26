//
//  TaskRow.swift
//  TestingCloudKit
//
//  Created by thaxz on 25/08/24.
//

import SwiftUI

struct TaskRow: View {
    let taskModel: TaskModel
    let onUpdate: (TaskModel) -> Void
    
    var body: some View {
        HStack {
            Text(taskModel.title)
            Spacer()
            Image(systemName: taskModel.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    var taskModelToUpdate = taskModel
                    taskModelToUpdate.isCompleted = !taskModel.isCompleted
                    onUpdate(taskModelToUpdate)
                }
        }
    }
}

#Preview {
    TaskRow(taskModel: TaskModel(title: "Task Mock", dateAssigned: Date()), onUpdate: { _ in })
}
