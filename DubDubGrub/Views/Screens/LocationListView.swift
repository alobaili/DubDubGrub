//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var locationManager: LocationManager

    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(
                        viewModel: LocationDetailViewModel(location: location)
                    )) {
                        LocationCell(location: location)
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .onAppear {
                CloudKitManager.shared.getCheckedInProfilesDictionary { result in
                    switch result {
                        case .success(let checkedInProfiles):
                            print(checkedInProfiles)
                        case .failure:
                            print("Error getting back dictionary.")
                    }
                }
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
