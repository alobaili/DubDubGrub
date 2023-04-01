//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 26/03/2023.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus {
    case checkedIn, checkedOut
}

final class LocationDetailViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var isShowingProfileModal = false
    @Published var isShowingProfileSheet = false
    @Published var checkedInProfiles = [DDGProfile]()
    @Published var isCheckedIn = false
    @Published var isLoading = false
    
    var location: DDGLocation
    var selectedProfile: DDGProfile?
    
    init(location: DDGLocation) {
        self.location = location
    }

    func determineColumns(for sizeCategory: ContentSizeCategory) -> [GridItem] {
        let numberOfColumns = sizeCategory >= .accessibilityMedium ? 1 : 3

        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    func getDirectionToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps(
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        )
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        UIApplication.shared.open(url)
    }

    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }

        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                    case .success(let record):
                        if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                            isCheckedIn = reference.recordID == location.id
                        } else {
                            isCheckedIn = false
                        }

                    case .failure:
                        alertItem = AlertContext.unableToGetCheckedInStatus
                }
            }
        }
    }
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
                case .success(let record):
                    switch checkInStatus {
                        case .checkedIn:
                            record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(
                                recordID: location.id,
                                action: .none
                            )
                            record[DDGProfile.kIsCheckedInNilCheck] = 1

                        case .checkedOut:
                            record[DDGProfile.kIsCheckedIn] = nil
                            record[DDGProfile.kIsCheckedInNilCheck] = nil
                    }

                    CloudKitManager.shared.save(record: record) { result in
                        DispatchQueue.main.async { [self] in
                            switch result {
                                case .success(let record):
                                    let profile = DDGProfile(record: record)

                                    switch checkInStatus {
                                        case .checkedIn:
                                            checkedInProfiles.append(profile)
                                        case .checkedOut:
                                            checkedInProfiles.removeAll { $0.id == profile.id }
                                    }

                                    isCheckedIn = checkInStatus == .checkedIn

                                case .failure:
                                    alertItem = AlertContext.unableToCheckInOrOut
                            }
                        }
                    }

                case .failure:
                    alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                    case .success(let profiles):
                        checkedInProfiles = profiles
                    case .failure:
                        alertItem = AlertContext.unableToGetCheckedInProfiles
                }

                hideLoadingView()
            }
        }
    }

    func show(profile: DDGProfile, in sizeCategory: ContentSizeCategory) {
        selectedProfile = profile
        
        if sizeCategory >= .accessibilityMedium {
            isShowingProfileSheet = true
        } else {
            isShowingProfileModal = true
        }
    }

    private func showLoadingView() {
        isLoading = true
    }

    private func hideLoadingView() {
        isLoading = false
    }
}
