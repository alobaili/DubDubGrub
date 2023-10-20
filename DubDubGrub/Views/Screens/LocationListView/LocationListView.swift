//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(value: location) {
                        LocationCell(
                            location: location,
                            profiles: viewModel.checkedInProfiles[location.id, default: []]
                        )
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(viewModel.createVoiceOverSummery(for: location)))
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .navigationDestination(for: DDGLocation.self) { location in
                viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)
            }
            .listStyle(.plain)
            .task {
                await viewModel.getCheckedInProfilesDictionary()
            }
            .refreshable {
                await viewModel.getCheckedInProfilesDictionary()
            }
            .alert(item: $viewModel.alertItem) { $0.alert }
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationManager())
}
