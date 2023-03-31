//
//  View+.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 21/03/2023.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        modifier(ProfileNameStyle())
    }

    func playHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
