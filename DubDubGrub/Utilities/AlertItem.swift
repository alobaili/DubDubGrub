//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 23/03/2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {

    // MARK: MapView Errors

    static let unableToGetLocations = AlertItem(
        title: Text("Locations Error"),
        message: Text("Unable to retrieve locations at this time.\nPlease try again."),
        dismissButton: .default(Text("OK"))
    )

    static let locationRestricted = AlertItem(
        title: Text("Location Restricted"),
        message: Text("Your location is restriced. This may be due to parental controls."),
        dismissButton: .default(Text("OK"))
    )

    static let locationDenied = AlertItem(
        title: Text("Location Denied"),
        message: Text("Dub Dub Grub does not have access to your location. To change that, go to your phone's Settings > Dub Dub Grub > Location."),
        dismissButton: .default(Text("OK"))
    )

    static let locationDisabled = AlertItem(
        title: Text("Location Service Disabled"),
        message: Text("Your phones location services are disabled. To change that, go to your phone's Settings > Privacy > Location Services."),
        dismissButton: .default(Text("OK"))
    )
}