//
//  EmptyCardSlot.swift
//  cards
//
//  Created by Hualiteq International on 2026/4/27.
//

import Foundation
import SwiftUI

struct EmptyCardSlot: View {
    var emptyCardSlotLineColor: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(emptyCardSlotLineColor, lineWidth: 1)
            .frame(width: 100, height: 130)

    }
}
