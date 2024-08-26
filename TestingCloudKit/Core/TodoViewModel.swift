//
//  TodoViewModel.swift
//  TestingCloudKit
//
//  Created by thaxz on 24/08/24.
//

import Foundation
import SwiftUI

final class TodoViewModel: ObservableObject {
    
    @ObservedObject var dbManager: CKManager = CKManager()
    
    @Published var textfieldText: String = ""
    
    var tasks: [TaskModel] {
        dbManager.tasksDictionary.values.compactMap({$0})
    }
    
    func createTask(){
        let taskModel = TaskModel(title: textfieldText, dateAssigned: Date(), isCompleted: false)
        print(taskModel)
        Task {
            do {
                try await dbManager.addTask(task: taskModel)
                print("mandei a task")
            } catch {
                print("Erro ao adicionar a task: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTaks(){
        Task {
            do {
                try await dbManager.populateTasks()
            } catch {
                print(error)
            }
        }
    }
    
    func updateTask(_ editedTask: TaskModel){
        Task {
            do {
                try await dbManager.updateTask(editedTask: editedTask)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteTask(_ indexSet: IndexSet){
        guard let index = indexSet.map({ $0 }).last else { return }
        let task = dbManager.tasks[index]
        Task {
            do {
                try await dbManager.deleteTask(taskToBeDeleted: task)
            } catch {
                print(error)
            }
        }
    }
    
}
