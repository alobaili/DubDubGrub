//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 21/03/2023.
//

import SwiftUI

struct DDGButton: View {
    var title: String
    var color: Color = .brandPrimary

    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview("Light Mode") {
    DDGButton(title: "Test Button")
}

#Preview("Dark Mode") {
    DDGButton(title: "Test Button")
        .preferredColorScheme(.dark)
}

#Preview("Dark Lanscape", traits: .landscapeRight) {
    DDGButton(title: "Test Button")
        .preferredColorScheme(.dark)
}
