//
//  ProjectManager.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/16/24.
//

import Foundation
import FirebaseFirestore // <-- Import Firestore framework
import FirebaseFirestoreSwift // <-- Import additional FirebaseSwift framework

@Observable
class ProjectManager {

//    var projects: [Project] = []

    private let dataBase = Firestore.firestore() // <-- Add an instance of the Firestore used to interact with your Firestore database

    init() {

        getProjects() // <-- Start fetching messages when MessageManager is created

    }

    func getProjects() {

        // Access the "Messages" collection group in Firestore and listen for any changes
        dataBase.collectionGroup("codeSnippets").addSnapshotListener { querySnapshot, error in

            // Get the documents for the messages collection (a document represents a message in this case)
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            // Map Firestore documents to Message objects
            _ = documents.compactMap { document in
                do {

                    // Decode message document to your Message data model
                    print(document, " DOCUMENT HERE")
                    return try document.data(as: Project.self)
                } catch {
                    print("Error decoding document into projects: \(error)")
                    return nil
                }
            }
            
        }
    }

}
