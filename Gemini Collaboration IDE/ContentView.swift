//
//  ContentView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/13/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    @State var text: String = ""
    @State var finalText: String = ""
    var body: some View {
        VStack {
            Text("\(text)")
        }
        .onAppear(perform: {
            Task {
                //                evaluatePython(stringText: "print('Hi')")
                finalText = await testingText()
//                typingEffect()
            }
        })
        .padding()
    }
    
    func testingText() async -> String{
        let model = GenerativeModel(name: "gemini-pro", apiKey: "")
        let prompt = "Give me code in python to print the contents of an array and call the function but do not display the output. Do not include comments"
        do{
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                print(text)
                return text
            }
        }
        catch{
            print(error.localizedDescription)
        }
        return "Empty"
    }
    
    func typingEffect(at position: Int = 0){
        let charactersToSkip: Set<Character> = ["`"]
        if finalText.starts(with: "```python"){
            finalText = String(finalText.dropFirst(9))
        }
        if position < finalText.count{
            let index = finalText.index(finalText.startIndex, offsetBy: position)
            let characterToAdd = finalText[index]
            if charactersToSkip.contains(characterToAdd){
                typingEffect(at: position + 1)
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    text.append(characterToAdd)
                    typingEffect(at: position + 1)
                }
            }
        }
        if position == finalText.count{
            evaluatePython(pythonCode: text){ codeHere in
                DispatchQueue.main.async {
                    if let codeHere = codeHere {
                        print(codeHere)
                    }
                }
            }
        }
    }
    
    func evaluatePython(pythonCode: String, completion: @escaping (String?) -> Void){
        let url = URL(string: "http://127.0.0.1:8000")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: String] = ["code": pythonCode]
        
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
    ContentView()
}
