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
    let container = CKContainer.default()

    func getUserRecord() async throws {
        let recordID = try await container.userRecordID()
        let record = try await container.publicCloudDatabase.record(for: recordID)
        userRecord = record

        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }

    func getLocations() async throws -> [DDGLocation] {
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        query.sortDescriptors = [sortDescriptor]

        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }

        return records.map(DDGLocation.init)
    }

    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [DDGProfile] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }

        return records.map(DDGProfile.init)
    }

    func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID: [DDGProfile]] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        var checkedInProfiles = [CKRecord.ID: [DDGProfile]]()

        let (matchResults, cursor) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }

        for record in records {
            guard
                let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference
            else {
                continue
            }

            let profile = DDGProfile(record: record)
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }

        guard let cursor else { return checkedInProfiles }

        return try await continueWithCheckedInProfilesDictionary(
            cursor: cursor,
            dictionary: checkedInProfiles
        )
    }

    private func continueWithCheckedInProfilesDictionary(
        cursor: CKQueryOperation.Cursor,
        dictionary: [CKRecord.ID: [DDGProfile]]
    ) async throws -> [CKRecord.ID: [DDGProfile]] {
        var checkedInProfiles = dictionary

        let database = container.publicCloudDatabase
        let (matchResults, cursor) = try await database.records(continuingMatchFrom: cursor)
        let records = matchResults.compactMap { _, result in try? result.get() }

        for record in records {
            guard
                let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference
            else {
                continue
            }

            let profile = DDGProfile(record: record)
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }

        guard let cursor else { return checkedInProfiles }

        return try await continueWithCheckedInProfilesDictionary(
            cursor: cursor,
            dictionary: checkedInProfiles
        )
    }

    func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)

        let (matchResults, _) = try await container.publicCloudDatabase.records(
            matching: query,
            desiredKeys: [DDGProfile.kIsCheckedIn]
        )
        let records = matchResults.compactMap { _, result in try? result.get() }

        var checkedInProfiles = [CKRecord.ID: Int]()

        for record in records {
            guard
                let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference
            else {
                continue
            }

            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }

        return checkedInProfiles
    }

    func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
        let database = container.publicCloudDatabase
        let (savedResults, _) = try await database.modifyRecords(saving: records, deleting: [])

        return savedResults.compactMap { _, result in try? result.get() }
    }

    func save(record: CKRecord) async throws -> CKRecord {
        try await container.publicCloudDatabase.save(record)
    }

    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord {
        try await container.publicCloudDatabase.record(for: id)
    }
}
