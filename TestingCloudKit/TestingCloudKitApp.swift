//
//  TestingCloudKitApp.swift
//  TestingCloudKit
//
//  Created by thaxz on 24/08/24.
//

import SwiftUI

@main
struct TestingCloudKitApp: App {
    @StateObject private var ckManager = CKManager()
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(ckManager)
        }
    }
}
