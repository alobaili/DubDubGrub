//
//  ProfileSheetView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 01/04/2023.
//

import SwiftUI

/// Alternative profile modal view for larger dynamic type sizes.
///
/// We present this as a sheet instead of a small pop up.
struct ProfileSheetView: View {
    var profile: DDGProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: profile.avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .accessibilityHidden(true)

                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .minimumScaleFactor(0.9)

                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))

                Text(profile.bio)
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
            }
            .padding()
        }
    }
}

#Preview {
    ProfileSheetView(profile: DDGProfile(record: MockData.profile))
        .environment(\.dynamicTypeSize, .accessibility5)
}
