//
//  CreateProjectView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/15/24.
//

import SwiftUI

struct CreateProjectView: View {
    @State private var documentName: String = ""
    var body: some View {
        ZStack{
            Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
            VStack{
                TextField("Type in the new document name", text: $documentName).frame(maxWidth: .infinity, minHeight: 50).background(Color.white).foregroundStyle(Color.black).border(Color.black, width: 2).padding(10)
                    .textInputAutocapitalization(.never)
                
                NavigationLink(destination: ContentView(documentName: documentName)){
                    SpecialButton(titleOfCard: "Create Document")
                }
            }.onAppear(){
                documentName = ""
            }
        }
    }
}

#Preview {
    CreateProjectView().environmentObject(AuthManager())
}
