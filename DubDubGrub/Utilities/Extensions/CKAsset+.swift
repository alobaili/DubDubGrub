//
//  CKAsset+.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimention: ImageDimention) -> UIImage {
        guard let fileURL else { return dimention.placeholder }

        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? dimention.placeholder
        } catch {
            return dimention.placeholder
        }
    }
}
