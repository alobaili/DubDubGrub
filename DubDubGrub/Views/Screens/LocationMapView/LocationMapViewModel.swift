//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import MapKit

final class LocationMapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var alertItem: AlertItem?
    @Published var locations = [DDGLocation]()

    func getLocations() {
        CloudKitManager.getLocations { [self] result in
            switch result {
                case .success(let locations):
                    self.locations = locations
                case .failure:
                    alertItem = AlertContext.unableToGetLocations
            }
        }
    }
}
