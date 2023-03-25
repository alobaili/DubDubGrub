//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var companyName = ""
    @State private var bio = ""
    @State private var avatar = PlaceholderImage.avatar
    @State private var isShowingPhotoPicker = false
    @State private var alertItem: AlertItem?

    var body: some View {
        VStack {
            ZStack {
                NameBackgroundView()

                HStack(spacing: 16) {
                    ZStack {
                        AvatarView(image: avatar, size: 84)

                        EditImage()
                    }
                    .padding(.leading, 12)
                    .onTapGesture {
                        isShowingPhotoPicker = true
                    }

                    VStack(spacing: 1) {
                        TextField("First Name", text: $firstName)
                            .profileNameStyle()

                        TextField("Last Name", text: $lastName)
                            .profileNameStyle()

                        TextField("Company name", text: $companyName)
                    }
                    .padding(.trailing, 16)
                }
                .padding()
            }

            VStack(alignment: .leading, spacing: 8) {
                CaractersRemainView(currentCount: bio.count)

                TextEditor(text: $bio)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)

            Spacer()

            Button {
                createProfile()
            } label: {
                DDGButton(title: "Create Profile")
            }
            .padding(.bottom)
        }
        .navigationTitle("Profile")
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
        .alert(item: $alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(image: $avatar)
        }
    }

    func isValidProfile() -> Bool {
        guard
            !firstName.isEmpty,
            !lastName.isEmpty,
            !companyName.isEmpty,
            !bio.isEmpty,
            avatar != PlaceholderImage.avatar,
            bio.count < 100
        else {
            return false
        }

        return true
    }

    func createProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }

        // Create the CKRecord from the profile view.
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()

        // Get our UserRecordID from the container.
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }

            // Get our UserRecord from the public database.
            CKContainer.default().publicCloudDatabase.fetch(
                withRecordID: recordID
            ) { userRecord, error in
                guard let userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                // Create reference in UserRecord to the DDGProfile we created.
                userRecord["userProfile"] = CKRecord.Reference(
                    recordID: profileRecord.recordID,
                    action: .none
                )

                // Create a CKOperation to save our User and Profile records.
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])

                operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
                    guard let savedRecords, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }

                    print(savedRecords)
                }

                CKContainer.default().publicCloudDatabase.add(operation)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}

struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

struct EditImage: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y: 30)
    }
}

struct CaractersRemainView: View {
    var currentCount: Int

    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : .pink)
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}
