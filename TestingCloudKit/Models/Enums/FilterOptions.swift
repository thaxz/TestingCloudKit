//
//  FilterOptions.swift
//  TestingCloudKit
//
//  Created by thaxz on 25/08/24.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    
    case all
    case completed
    case incomplete
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}
