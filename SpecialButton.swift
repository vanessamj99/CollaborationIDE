//
//  SpecialButton.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/15/24.
//

import SwiftUI

struct SpecialButton: View {
    var titleOfCard: String
    var body: some View {
        VStack{
            Text("\(titleOfCard)").font(.custom("BinaryCHRBRK", size: 24))
        }
        .frame(width: 180, height: 70)
        .background(Gradient(colors: [Color.blue, Color(red: 29/255, green: 95/255, blue: 117/255)])).overlay(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(Color.black, lineWidth: 10)
        ).foregroundColor(Color.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 10)))
        .shadow(color: Color.black, radius: 3, x: -5, y: -3)
    }
}

#Preview {
    SpecialButton(titleOfCard: "See Document")
}
