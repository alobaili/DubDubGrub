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
    var profileRecordID: CKRecord.ID?

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

                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference {
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }

    func getLocations(completion: @escaping (Result<[DDGLocation], Error>) -> Void) {
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))

        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        query.sortDescriptors = [sortDescriptor]

        CKContainer.default().publicCloudDatabase.perform(
            query,
            inZoneWith: nil
        ) { records, error in
            guard let records, error == nil else {
                completion(.failure(error!))
                return
            }

            let locations = records.map(DDGLocation.init)

            completion(.success(locations))
        }
    }

    func getCheckedInProfiles(
        for locationID: CKRecord.ID,
        completion: @escaping (Result<[DDGProfile], Error>) -> Void
    ) {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        CKContainer.default().publicCloudDatabase.perform(
            query,
            inZoneWith: nil
        ) { records, error in
            guard let records, error == nil else {
                completion(.failure(error!))
                return
            }

            let profiles = records.map(DDGProfile.init)

            completion(.success(profiles))
        }
    }

    func getCheckedInProfilesDictionary(
        completion: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void
    ) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)

        var checkedInProfiles = [CKRecord.ID: [DDGProfile]]()

        operation.recordFetchedBlock = { record in
            let profile = DDGProfile(record: record)

            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {
                return
            }

            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }

        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            if let cursor {
                self.continueWithCheckedInProfilesDictionary(
                    cursor: cursor,
                    dictionary: checkedInProfiles
                ) { result in
                    switch result {
                        case .success(let profiles):
                            completion(.success(profiles))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            } else {
                completion(.success(checkedInProfiles))
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func continueWithCheckedInProfilesDictionary(
        cursor: CKQueryOperation.Cursor,
        dictionary: [CKRecord.ID: [DDGProfile]],
        completion: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void
    ) {
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: cursor)

        operation.recordFetchedBlock = { record in
            let profile = DDGProfile(record: record)

            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {
                return
            }

            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }

        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            if let cursor {
                self.continueWithCheckedInProfilesDictionary(
                    cursor: cursor,
                    dictionary: checkedInProfiles
                ) { result in
                    switch result {
                        case .success(let profiles):
                            completion(.success(profiles))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            } else {
                completion(.success(checkedInProfiles))
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }

    func getCheckedInProfilesCount(
        completion: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void
    ) {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]

        var checkedInProfiles = [CKRecord.ID: Int]()

        operation.recordFetchedBlock = { record in
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {
                return
            }

            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }

        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            completion(.success(checkedInProfiles))
        }

        CKContainer.default().publicCloudDatabase.add(operation)
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

    func save(record: CKRecord, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record, error == nil else {
                completion(.failure(error!))
                return
            }

            completion(.success(record))
        }
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
