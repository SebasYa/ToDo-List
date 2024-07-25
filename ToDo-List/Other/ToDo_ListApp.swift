//
//  ToDo_ListApp.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import UIKit
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ToDo_ListApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
//    init() {
//        FirebaseApp.configure()
//
//    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
