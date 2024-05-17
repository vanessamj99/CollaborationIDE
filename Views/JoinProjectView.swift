//
//  JoinProjectView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/15/24.
//

import SwiftUI

struct JoinProjectView: View {
    @State var documentName: String = ""
    @State private var isJoinButtonTapped: Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    TextField("Type in an existing document name to join", text: $documentName).frame(maxWidth: .infinity, minHeight: 50).background(Color.white).border(Color.black, width: 2).padding(10)
                        .textInputAutocapitalization(.never)
                    
                        NavigationLink(destination: ContentView(documentName: documentName)){
                            SpecialButton(titleOfCard: "See Document")
                        }
                    
                    Spacer()
                    Spacer()
                }.onAppear(){
                    documentName = ""
                }
                
            }
        }
    }
}

#Preview {
    JoinProjectView().environmentObject(AuthManager())
}
