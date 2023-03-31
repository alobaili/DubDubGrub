//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import MapKit
import SwiftUI

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: locationManager.locations
            ) { location in
                MapAnnotation(
                    coordinate: location.location.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.75)
                ) {
                    DDGAnnotation(
                        location: location,
                        number: viewModel.checkedInProfiles[location.id, default: 0]
                    )
                    .accessibilityLabel(Text("Map Pin \(location.name) \(viewModel.checkedInProfiles[location.id, default: 0]) people checked in."))
                    .onTapGesture {
                        locationManager.selectedLocation = location
                        viewModel.isShowingDetailView = true
                    }
                }
            }
            .accentColor(.brandSecondry)
            .ignoresSafeArea()

            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)

                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView {
                LocationDetailView(
                    viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!)
                )
                .toolbar {
                    Button("Dismiss") {
                        viewModel.isShowingDetailView = false
                    }
                }
            }
            .accentColor(.brandPrimary)
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .onAppear {
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }

            viewModel.getCheckedInCount()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
            .environmentObject(LocationManager())
    }
}
