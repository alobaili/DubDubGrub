//
//  MockData.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import CloudKit

struct MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: "DGGLocation")
        record[DDGLocation.kName] = "Abdulaziz's Bar and Grill"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test description. Isn't it awesom. Not sure how long to make it to test the 3 lines."
        record[DDGLocation.kWebsiteURL] = "https://apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "111-111-1111"

        return record
    }
}
