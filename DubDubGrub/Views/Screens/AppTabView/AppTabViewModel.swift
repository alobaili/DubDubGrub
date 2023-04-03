//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 31/03/2023.
//

import SwiftUI

extension AppTabView {
    final class AppTabViewModel: ObservableObject {
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet {
                isShowingOnboardView = hasSeenOnboardView
            }
        }

        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            }
        }
    }
}
