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
    
    private var dataBase = CKContainer(identifier: "iCloud.com.br.ufpe.cin.academy.tmc4.TestingCloudKit").privateCloudDatabase
    
    @Published var tasksDictionary: [CKRecord.ID: TaskModel] = [:]
    
    var tasks: [TaskModel] {
        tasksDictionary.values.compactMap({$0})
    }
    
    // CRUD
    
    func addTask(task: TaskModel) async throws {
        let record = try await dataBase.save(task.record)
    }
    
    func getTasks() async throws {
        let query = CKQuery(recordType: TaskRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await dataBase.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get()}
        records.forEach { record in
            tasksDictionary[record.recordID] = TaskModel(record: record)
        }
    }
    
}
