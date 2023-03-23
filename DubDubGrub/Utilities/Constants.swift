//
//  Constants.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import UIKit

enum RecordType {
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum PlaceholderImage {
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimention {
    case square, banner

    static func getPlaceholder(for dimention: ImageDimention) -> UIImage {
        switch dimention {
            case .square: return PlaceholderImage.square
            case .banner: return PlaceholderImage.banner
        }
    }
}
