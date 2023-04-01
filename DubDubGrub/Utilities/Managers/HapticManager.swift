//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 01/04/2023.
//

import UIKit

struct HapticManager {
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
