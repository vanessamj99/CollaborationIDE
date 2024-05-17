//
//  CodeManager.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/20/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class CodeManager: ObservableObject {
    var authManager: AuthManager
    @Published var snippets: [QueryDocumentSnapshot] = []
    let dbRef: Firestore = Firestore.firestore()
    private var listener: ListenerRegistration?
    @Published var _codeUpdates: String = ""
    var documentName: String
    
    init(documentName: String, authManager: AuthManager) {
        self.documentName = documentName
        self.authManager = authManager
        observeUpdates()
    }
    
    func observeUpdates() {
        guard !documentName.isEmpty else {
            return
        }
        listener = dbRef.collection("codeSnippets").document(documentName)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                if let code = document.data()?["code"] as? String {
                    DispatchQueue.main.async {
                        self._codeUpdates = code
                    }
                }
            }
    }
    
    func retrieveLastCode() async {
           do {
               let document = try await dbRef.collection("codeSnippets").document(documentName).getDocument()
               if let code = document.data()?["code"] as? String {
                   DispatchQueue.main.async {
                       self._codeUpdates = code
                   }
               }
               else if document.data() == nil {
                   DispatchQueue.main.async {
                       self._codeUpdates = ""
                   }
               }
           } catch {
               print("Error retrieving last code: \(error)")
           }
       }

    func saveUpdate(_ newText: String) {
        if (authManager.user?.uid) != nil {
               dbRef.collection("codeSnippets").document(documentName)
                .setData(["code": newText, "username": authManager.userEmail?.description ?? "no user email"], merge: true)
           }
    }
    
    func getAllSnippetsForUser(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
          if let username = authManager.userEmail?.description {
              dbRef.collection("codeSnippets")
                  .whereField("username", isEqualTo: username)
                  .getDocuments { (querySnapshot, error) in
                      completion(querySnapshot?.documents, error)
                  }
          } else {
              completion(nil, nil) // Handle the case where username is nil
          }
      }
    
}
