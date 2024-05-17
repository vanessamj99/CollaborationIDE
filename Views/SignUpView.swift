//
//  SignUpView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/16/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @ObservedObject var codeManager: CodeManager
    var body: some View {
        NavigationStack {
            ZStack{
                Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Code and Collaborate On The Go").font(.custom("BinaryCHRBRK", size: 50)).foregroundColor(Color.white).multilineTextAlignment(.center)
                    TextField("Full Name", text: $name).frame(height: 40).background(Color.white).foregroundStyle(Color.black).padding()
                    TextField("Username", text: $username).frame(height: 40).background(Color.white).foregroundStyle(Color.black).padding()
                    TextField("Password", text: $password).frame(height: 40).background(Color.white).foregroundStyle(Color.black).padding()
                    NavigationLink(destination: AllCards().environmentObject(codeManager)){
                        SpecialButton(titleOfCard: "Join")
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SignUpView(codeManager: CodeManager(documentName: "", authManager: AuthManager()))
}
