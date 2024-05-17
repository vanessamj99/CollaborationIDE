//
//  LoginView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/16/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    var body: some View {
        ZStack{
            Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Code and Collaborate On The Go").font(.custom("BinaryCHRBRK", size: 50)).foregroundColor(Color.white).multilineTextAlignment(.center)
                    
                TextField("Email", text: $email).frame(height: 40).background(Color.white).foregroundStyle(Color.black).padding()
                TextField("Password", text: $password).frame(height: 40).background(Color.white).foregroundStyle(Color.black).padding()
                Button(action: {
                    authManager.signIn(email: email, password: password)
                }, label: {
                    SpecialButton(titleOfCard: "Login")
                })
                Button(action: {
                    authManager.signUp(email: email, password: password)
                }, label: {
                    
                    SpecialButton(titleOfCard: "Sign Up")
                })
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthManager())
}
