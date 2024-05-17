//
//  GeminiView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/15/24.
//

import SwiftUI
import GoogleGenerativeAI

struct GeminiView: View {
    @State var codeHelp: String = ""
    @State var result: String = ""
    @State var existingCode: String = ""
    @State var text: String = ""
    var body: some View {
        NavigationStack{
        ZStack{
                VStack{
                    TextField("Type in your code help question", text: $codeHelp).frame(maxWidth: .infinity, minHeight: 50).background(Color.white).border(Color.black, width: 2).padding(10)
                        .textInputAutocapitalization(.never)
                    Button {
                        Task{
                            if codeHelp.contains("existing code"){
                                let codeHelpEdited = codeHelp.replacingOccurrences(of: "existing code", with: "existing code: \(existingCode)")
                                await testingText(codeRequest: codeHelpEdited)
                                typingEffect()
                            }
                            else if codeHelp.contains("my code"){
                                let codeHelpEdited = codeHelp.replacingOccurrences(of: "existing code", with: "my code: \(existingCode)")
                                await testingText(codeRequest: codeHelpEdited)
                                typingEffect()
                            }
                            else if codeHelp.contains("my existing code"){
                                let codeHelpEdited = codeHelp.replacingOccurrences(of: "existing code", with: "my existing code: \(existingCode)")
                                await testingText(codeRequest: codeHelpEdited)
                                typingEffect()
                            }
                            else {
                                await testingText(codeRequest: codeHelp)
                                typingEffect()
                            }
                        }
                    } label: {
                        SpecialButton(titleOfCard: "Ask for Help")
                    }
                    ScrollView{
                        Text("\(text)").foregroundStyle(Color.white).padding()
                    }
                }
                
                
                
            }
        }
    }
    
    func testingText(codeRequest: String) async{
        let model = GenerativeModel(name: "gemini-pro", apiKey: "")
        var prompt = ""
        if codeRequest.contains("existing code"){
            prompt = codeRequest
        }
        else {
            prompt = "Do not include any comments. \(codeRequest) and call the function but do not display the output."
        }
        do{
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                var finalText = text
                if finalText.starts(with: "```python"){
                    finalText = String(finalText.dropFirst(9))
                }
                finalText = finalText.replacingOccurrences(of: "`", with: "")
                result = finalText
                print(result)
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
        func typingEffect(at position: Int = 0){
            if position < result.count{
                let index = result.index(result.startIndex, offsetBy: position)
                let characterToAdd = result[index]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    text.append(characterToAdd)
                    typingEffect(at: position + 1)
                }
            }
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

#Preview {
    GeminiView(codeHelp: "Give me a function that runs a for loop")
}
