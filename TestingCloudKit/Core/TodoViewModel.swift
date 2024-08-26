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
    
    
}
