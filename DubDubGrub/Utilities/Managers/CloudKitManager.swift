//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import CloudKit

final class CloudKitManager {
    static let shared = CloudKitManager()

    private init() {}

    var userRecord: CKRecord?

    func getUserRecord() {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }

            CKContainer.default().publicCloudDatabase.fetch(
                withRecordID: recordID
            ) { userRecord, error in
                guard let userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                self.userRecord = userRecord
            }
        }
    }

    func getLocations(completion: @escaping (Result<[DDGLocation], Error>) -> Void) {
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

    func batchSave(
        records: [CKRecord],
        completion: @escaping (Result<[CKRecord], Error>) -> Void
    ) {
        let operation = CKModifyRecordsOperation(recordsToSave: records)

        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            guard let savedRecords, error == nil else {
                completion(.failure(error!))
                return
            }

            completion(.success(savedRecords))
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func fetchRecord(
        with id: CKRecord.ID,
        completion: @escaping (Result<CKRecord, Error>) -> Void
    ) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record, error == nil else {
                completion(.failure(error!))
                return
            }

            completion(.success(record))
        }
    }
}
