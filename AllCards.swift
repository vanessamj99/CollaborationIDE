//
//  AllCards.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/3/24.
//

import SwiftUI

struct AllCards: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var codeManager: CodeManager
    var body: some View {
        NavigationStack {
            ZStack{
                Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                VStack{
                    
                    Text("Code and Collaborate On The Go").font(.custom("BinaryCHRBRK", size: 50)).foregroundColor(Color.white).multilineTextAlignment(.center)
                        
                    Spacer()
                    HStack {
                        NavigationLink(destination: AllProjectsView() .environmentObject(authManager).environmentObject(codeManager)){
                            CardView(titleOfCard: "Coding Projects")
                        }
                        NavigationLink(destination: CreateProjectView()){
                            CardView(titleOfCard: "Create Project")
                        }
                        
                    }
                    HStack{
                        NavigationLink(destination: JoinProjectView()){
                            CardView(titleOfCard: "Join Project")
                        }
                    }
                    Spacer()
                    Spacer()
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        authManager.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right").tint(Color.white)
                    })
                }
            }
        }
    }
}

#Preview {
    AllCards()
}
