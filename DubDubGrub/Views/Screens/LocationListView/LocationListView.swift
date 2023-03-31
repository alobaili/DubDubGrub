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

    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(
                        viewModel: LocationDetailViewModel(location: location)
                    )) {
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
            .onAppear {
                viewModel.getCheckedInProfilesDictionary()
            }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
            .environmentObject(LocationManager())
    }
}
