//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 30/03/2023.
//

import CloudKit

final class LocationListViewModel: ObservableObject {
    @Published var checkedInProfiles = [CKRecord.ID: [DDGProfile]]()

    func getCheckedInProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let checkedInProfiles):
                        self.checkedInProfiles = checkedInProfiles
                    case .failure:
                        print("Error getting back dictionary.")
                }
            }
        }
    }
}
