//
//  ContentView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/13/24.
//

import SwiftUI
import GoogleGenerativeAI
import Combine

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State var text: String = ""
    @State var finalText: String = ""
    @State var result: String = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showingResult = false
    @ObservedObject var codeManager : CodeManager
    var documentName: String
    @State private var showGemini = false
    @State private var showOutputWord = false
    
    init(documentName: String){
        self.documentName = documentName
        self.codeManager = CodeManager(documentName: documentName, authManager: AuthManager())
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("codingBackground").resizable().aspectRatio(contentMode: .fill).frame(minWidth: 0, maxWidth: .infinity).edgesIgnoringSafeArea(.all)
                
                VStack {
                    AgoraKitView()
                        TextEditor(text: $codeManager._codeUpdates)
                            .border(Color.yellow)
                            .scrollContentBackground(.hidden)
                            .background(Color(red: 3/255, green: 26/255, blue: 44/255))
                            .foregroundColor(.white)
                            .padding()
                            .autocorrectionDisabled()
                            .onChange(of: codeManager._codeUpdates) {
                                codeManager._codeUpdates = codeManager._codeUpdates.lowercased()
                            }.textInputAutocapitalization(.never)

                        if showOutputWord {
                            Text("Output:").foregroundStyle(Color.white)
                        }
                        Text("\(result)").foregroundStyle(Color.white)
                    
                    if !showGemini {
                        Button {
                            showGemini = true
                        } label: {
                            SpecialButton(titleOfCard: "Want Gemini Help")
                        }
                    }
                    if showGemini {
                        GeminiView(existingCode: codeManager._codeUpdates.lowercased())
                        Spacer()
                        Button(action: {
                            showGemini = false
                        }, label: {
                            SpecialButton(titleOfCard: "Thanks for the Help!")
                        })
                    }
                    Spacer()
                }
                .onAppear {
                    
                    codeManager.observeUpdates()
                    publishingText()

                    Task {
                        await codeManager.retrieveLastCode()
                        publishingText()
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        authManager.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right").tint(Color.white)
                    })
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        Task {
                            text = ""
                            showOutputWord = true
                            evaluatePython(pythonCode: codeManager._codeUpdates.lowercased()) { codeHere in
                                if let codeHere = codeHere {
                                    result = codeHere
                                    print("Evaluation result: \(result)")
                                } else {
                                    print("Evaluation failed.")
                                }
                            }
                            
                        }
                    }) {
                        Image(systemName: "play.fill").tint(Color.white)
                    }
                }
                
            }
        }
    }
    
    
    func publishingText() {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: nil)
            .compactMap { notification in
                return (notification.object as? UITextView)?.text
            }
            .sink { newText in
                updateCode(newCode: newText)
            }
            .store(in: &cancellables)
    }
    

    func updateCode(newCode: String) {
        codeManager.saveUpdate(newCode)
    }
    
    func evaluatePython(pythonCode: String, completion: @escaping (String?) -> Void){
        let url = URL(string: "") ?? URL(string: "http://127.0.0.1:8000")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let escapedPythonCode = pythonCode.replacingOccurrences(of: "“", with: "\"")
        let escapedPythonCodeEnd = escapedPythonCode.replacingOccurrences(of: "”", with: "\"")
        let parameters: [String: String] = ["code": escapedPythonCodeEnd]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            request.httpBody = jsonData
        } catch {
            print("Error converting payload to JSON: \(error)")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let code = jsonResponse?["output"] as? String {
                    completion(code)
                } else {
                    print("Unexpected response format.")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON response: \(error)")
                completion(nil)
            }
        }
        
        // Start the task
        task.resume()
        
    }
    
    
    
}
