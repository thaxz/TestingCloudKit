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
    
}

extension TaskModel {
    
    var record: CKRecord {
        let record = CKRecord(recordType: TaskRecordKeys.type.rawValue)
        record[TaskRecordKeys.title.rawValue] = title
        record[TaskRecordKeys.dateAssigned.rawValue] = dateAssigned
        record[TaskRecordKeys.isCompleted.rawValue] = isCompleted
        return record
    }
    
    
}
