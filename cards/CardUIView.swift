//
//  CardUI.swift
//  cards
//
//  Created by Hualiteq International on 2026/4/27.
//

import Foundation
import SwiftUI

struct CardUIView: View {
    var cardColor: Color
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(width: 100, height: 130)
                .foregroundColor(.brown)
                .cornerRadius(10)
                .offset(x: 5)
                .offset(y: 8)
            
            Rectangle()
                .frame(width: 100, height: 130)
                .foregroundColor(cardColor)
                .cornerRadius(10)
            
        }
    }
}
