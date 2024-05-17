//
//  Gemini_Collaboration_IDEApp.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/13/24.
//

import SwiftUI
import FirebaseCore

//class AppDelegate: NSObject, UIApplicationDelegate {
//    
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}

@main
struct Gemini_Collaboration_IDEApp: App {
    @StateObject private var authManager = AuthManager()
    @State private var codeManager: CodeManager? 
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
           FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
//            AllCards()
            if authManager.user != nil {
                AllCards().environmentObject(authManager).environmentObject(codeManager ?? CodeManager(documentName: "", authManager: authManager))
            }
            else{
                LoginView().environmentObject(authManager)
            }
        }
    }
}
