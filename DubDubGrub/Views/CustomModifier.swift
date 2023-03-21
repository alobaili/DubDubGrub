//
//  CustomModifier.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 21/03/2023.
//

import SwiftUI

struct ProfileNameStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}
