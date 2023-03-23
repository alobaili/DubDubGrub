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
        let placeholder = ImageDimention.getPlaceholder(for: dimention)

        guard let fileURL else { return placeholder }

        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}
