//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView {
    final class LocationMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        @Published var checkedInProfiles = [CKRecord.ID: Int]()
        @Published var isShowingDetailView = false
        @Published var alertItem: AlertItem?
        @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        let deviceLocationManager = CLLocationManager()

        override init() {
            super.init()

            deviceLocationManager.delegate = self
        }

        func requestAllowOnceLocationPermission() {
            deviceLocationManager.requestLocation()
        }

        func locationManager(
            _ manager: CLLocationManager,
            didUpdateLocations locations: [CLLocation]
        ) {
            guard let currentLocation = locations.last else { return }

            withAnimation {
                region = MKCoordinateRegion(
                    center: currentLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did fail with error. \(error)")
        }

        func getLocations(for locationManager: LocationManager) {
            CloudKitManager.shared.getLocations { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                        case .success(let locations):
                            locationManager.locations = locations
                        case .failure:
                            alertItem = AlertContext.unableToGetLocations
                    }
                }
            }
        }

        func getCheckedInCount() {
            CloudKitManager.shared.getCheckedInProfilesCount { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                        case .success(let checkedInProfiles):
                            self.checkedInProfiles = checkedInProfiles
                        case .failure:
                            alertItem = AlertContext.checkedInCount
                    }
                }
            }
        }

        @ViewBuilder func createLocationDetailView(
            for location: DDGLocation,
            in dynamicTypeSize: DynamicTypeSize
        ) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
                    .embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
}
