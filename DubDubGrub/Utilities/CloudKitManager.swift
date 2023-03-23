//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import CloudKit

struct CloudKitManager {
    static func getLocations(completion: @escaping (Result<[DDGLocation], Error>) -> Void) {
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))

        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        query.sortDescriptors = [sortDescriptor]

        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            guard let records else { return }

            let locations = records.map { $0.convertToDDGLocation() }

            completion(.success(locations))
        }
    }
}
