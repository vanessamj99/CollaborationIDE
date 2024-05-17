//
//  Project.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/16/24.
//

struct Project: Hashable, Identifiable, Codable {
    let id: String
    let code: String
    let username: String
}
