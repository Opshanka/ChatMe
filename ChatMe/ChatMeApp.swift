//
//  ChatMeApp.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ChatMeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .onAppear() {
                    Task {
                        await FirebaseService.shared.exportAllUserToFirestoreFromJSONResponseIfNeeded()
                    }
                }
        }
    }
}
