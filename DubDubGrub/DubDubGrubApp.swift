//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
    let locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(locationManager)
        }
    }
}
