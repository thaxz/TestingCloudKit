//
//  TaskModel.swift
//  TestingCloudKit
//
//  Created by thaxz on 24/08/24.
//

import Foundation
import CloudKit

struct TaskModel {
    
    var recordId: CKRecord.ID?
    let title: String
    let dateAssigned: Date
    var isCompleted: Bool = false
    
    var record: CKRecord {
        let record = CKRecord(recordType: TaskRecordKeys.type.rawValue)
        record[TaskRecordKeys.title.rawValue] = title
        record[TaskRecordKeys.dateAssigned.rawValue] = dateAssigned
        record[TaskRecordKeys.isCompleted.rawValue] = isCompleted
        return record
    }
    
}

extension TaskModel {
    
    // Converting record in TaskModel
    init?(record: CKRecord){
        guard let title = record[TaskRecordKeys.title.rawValue] as? String,
              let dateAssigned = record[TaskRecordKeys.dateAssigned.rawValue] as? Date,
              let isCompleted = record[TaskRecordKeys.isCompleted.rawValue] as? Bool else {
            return nil
        }
        self.init(recordId: record.recordID, title: title, dateAssigned: dateAssigned, isCompleted: isCompleted)
    }
    
}
