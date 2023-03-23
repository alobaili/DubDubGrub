//
//  CKRecord+.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }

    func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
