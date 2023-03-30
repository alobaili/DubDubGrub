//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 31/03/2023.
//

import CoreLocation

final class AppTabViewModel: NSObject, ObservableObject {
    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?

    var deviceLocationManager: CLLocationManager?

    let kHasSeenObnoardView = "hasSeenOnboardView"

    var hasSeenOnboardView: Bool {
        UserDefaults.standard.bool(forKey: kHasSeenObnoardView)
    }

    func runStartupChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenObnoardView)
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
}

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
