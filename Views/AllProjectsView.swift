//
//  AllProjectsView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/15/24.
//

import SwiftUI

struct AllProjectsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var codeManager: CodeManager
    var body: some View {
        NavigationStack {
            ZStack{
                Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Projects for \(authManager.userEmail?.description ?? "Unknown User")")
                        .font(.title).foregroundStyle(Color.white)
                    
                    ScrollView{
                        ForEach(codeManager.snippets, id: \.self) { snippet in
                            NavigationLink(destination: ContentView(documentName: snippet.data()["document"] as! String)){
                                VStack{
                                    Text("\(snippet.data()["document"] as? String ?? "No documents")").font(.custom("BinaryCHRBRK", size: 20))
                                }
                                .frame(width: 200, height: 70)
                                .background(Gradient(colors: [Color.blue, Color(red: 29/255, green: 95/255, blue: 117/255)])).overlay(
                                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                                        .stroke(Color.black, lineWidth: 10)
                                ).foregroundColor(Color.white)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 10)))
                                .shadow(color: Color.black, radius: 3, x: -5, y: -3)
                            }
                        }
                    }
                    .onAppear {
                        codeManager.getAllSnippetsForUser { documents, error in
                            if let error = error {
                                print("Error fetching snippets: \(error)")
                            } else {
                                codeManager.snippets = documents ?? []
                            }
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    AllProjectsView().environmentObject(AuthManager())
//}
