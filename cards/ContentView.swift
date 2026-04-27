//
//  ContentView.swift
//  cards
//
//  Created by Hualiteq International on 2026/4/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        
            Text("Adventure time")
                .font(.callout)
                .fontDesign(.monospaced)
            
            Rectangle()
                .frame(width: 100, height: 130)
                .foregroundColor(.clear)
                .cornerRadius(10)
                .border(Color.pink)
                .cornerRadius(10)
            
            // MARK: - Card Decks
            HStack {
                CardUIView(cardColor: .yellow)
                CardUIView(cardColor: .yellow)
                CardUIView(cardColor: .yellow)
            }.padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
