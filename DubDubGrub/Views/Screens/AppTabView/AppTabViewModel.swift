//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 31/03/2023.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var isShowingOnboardView = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet {
                isShowingOnboardView = hasSeenOnboardView
            }
        }

        var deviceLocationManager: CLLocationManager?

        func runStartupChecks() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkIfLocationServicesIsEnabled()
            }
        }

        func checkIfLocationServicesIsEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                deviceLocationManager = CLLocationManager()
                deviceLocationManager!.delegate = self
            } else {
                alertItem = AlertContext.locationDisabled
            }
        }

        private func checkLocationAuthorization() {
            guard let deviceLocationManager else { return }

            switch deviceLocationManager.authorizationStatus {
                case .notDetermined:
                    deviceLocationManager.requestWhenInUseAuthorization()
                case .restricted:
                    alertItem = AlertContext.locationRestricted
                case .denied:
                    alertItem = AlertContext.locationDenied
                case .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
            }
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}
