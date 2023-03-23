//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations = [DDGLocation]()
}
