//
//  CardView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/3/24.
//

import SwiftUI

struct CardView: View {
    var titleOfCard: String
    var body: some View {
        VStack{
            Text("\(titleOfCard.split(separator: " ")[0])").foregroundStyle(Color.white).font(.custom("BinaryCHRBRK", size: 36)).foregroundStyle(Gradient(colors: [Color.blue, Color.purple]))
            Text("\(titleOfCard.split(separator: " ")[1])").foregroundStyle(Color.white).font(.custom("BinaryCHRBRK", size: 36))
            

        }
        .frame(width: 180, height: 150)
        .background(Gradient(colors: [Color.blue, Color(red: 29/255, green: 95/255, blue: 117/255)])).overlay(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(Color.black, lineWidth: 10)
        )
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 10)))
        .shadow(color: Color.black, radius: 3, x: -5, y: -3)
        
        
    }
}

#Preview {
    CardView(titleOfCard: "Coding Projects")
}
