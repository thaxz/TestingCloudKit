//
//  CKManager.swift
//  TestingCloudKit
//
//  Created by thaxz on 24/08/24.
//

import Foundation
import CloudKit

@MainActor
final class CKManager: ObservableObject {
    
    var database = CKContainer(identifier: "iCloud.com.br.ufpe.cin.academy.tmc4.TestingCloudKit").privateCloudDatabase
    
    @Published var tasksDictionary: [CKRecord.ID: TaskModel] = [:]
    
    var tasks: [TaskModel] {
        tasksDictionary.values.compactMap { $0 }
    }
    
    func addTask(task: TaskModel) async throws {
        let record = try await database.save(task.record)
        guard let task = TaskModel(record: record) else { return }
        tasksDictionary[task.recordId!] = task
    }
    
    func updateTask(editedTask: TaskModel) async throws {
        
        tasksDictionary[editedTask.recordId!]?.isCompleted = editedTask.isCompleted
        
        do {
            let record = try await database.record(for: editedTask.recordId!)
            record[TaskRecordKeys.isCompleted.rawValue] = editedTask.isCompleted
            try await database.save(record)
        } catch {
            tasksDictionary[editedTask.recordId!] = editedTask
        }
    }
    
    func deleteTask(taskToBeDeleted: TaskModel) async throws {
        
        tasksDictionary.removeValue(forKey: taskToBeDeleted.recordId!)
        
        do {
            let _ = try await database.deleteRecord(withID: taskToBeDeleted.recordId!)
        } catch {
            tasksDictionary[taskToBeDeleted.recordId!] = taskToBeDeleted
            print(error)
        }
        
    }
    
    func populateTasks() async throws {
        
        let query = CKQuery(recordType: TaskRecordKeys.type.rawValue,
                            predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            tasksDictionary[record.recordID] = TaskModel(record: record)
        }
    }
    
    func filterTask(by filterOptions: FilterOptions) -> [TaskModel] {
        switch filterOptions {
        case .all:
            return tasks
        case .completed:
            return tasks.filter { $0.isCompleted }
        case .incomplete:
            return tasks.filter { !$0.isCompleted }
        }
    }
    
    // User
    
    func addUser(userID: String, name: String, email: String) async throws {
        let userRecord = CKRecord(recordType: "User")
        userRecord["userID"] = userID as CKRecordValue
        userRecord["name"] = name as CKRecordValue
        userRecord["email"] = email as CKRecordValue
        
        try await database.save(userRecord)
    }
    
    func fetchUser(userID: String) async throws -> CKRecord? {
        let predicate = NSPredicate(format: "userID == %@", userID)
        let query = CKQuery(recordType: "User", predicate: predicate)
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        return records.first
    }
    
    
}
