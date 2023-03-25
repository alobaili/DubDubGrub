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

    // MARK: ProfileView Errors

    static let invalidProfile = AlertItem(
        title: Text("Invalid Profile"),
        message: Text("All fields are required as well as a profile photo. Your bio must be less than 100 charachters.\nPlease try again."),
        dismissButton: .default(Text("OK"))
    )

    static let noUserRecord = AlertItem(
        title: Text("No User Record"),
        message: Text("You must log into iCloud on your phone in order to utilize Dub Dub Grubs profile. Please log in on your phones Settings screen."),
        dismissButton: .default(Text("OK"))
    )

    static let createProfileSuccess = AlertItem(
        title: Text("Profile Created Successfully"),
        message: Text("Your profile has successfully been created."),
        dismissButton: .default(Text("OK"))
    )

    static let createProfileFailure = AlertItem(
        title: Text("Failed to Create Profile"),
        message: Text("We were unable to create your profile at this time.\nPlease try again later or contact customer support if this persists."),
        dismissButton: .default(Text("OK"))
    )

    static let unableToGetProfile = AlertItem(
        title: Text("Unable to Retrieve Profile"),
        message: Text("We were unable to retrieve your profile at this time.\nPlease check your internet connection and try again later or contact customer support if this persists."),
        dismissButton: .default(Text("OK"))
    )
}
