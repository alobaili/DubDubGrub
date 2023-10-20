//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Abdulaziz Alobaili on 20/03/2023.
//

import SwiftUI
import CloudKit
import PhotosUI

@MainActor
struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @FocusState private var focusedTextField: ProfileTextField?

    enum ProfileTextField {
        case firstName, lastName, companyName, bio
    }

    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 16) {
                    ProfileImageView(viewModel: viewModel)

                    VStack(spacing: 1) {
                        TextField("First Name", text: $viewModel.firstName)
                            .focused($focusedTextField, equals: .firstName)
                            .profileNameStyle()
                            .textContentType(.givenName)
                            .onSubmit {
                                focusedTextField = .lastName
                            }
                            .submitLabel(.next)

                        TextField("Last Name", text: $viewModel.lastName)
                            .focused($focusedTextField, equals: .lastName)
                            .profileNameStyle()
                            .textContentType(.familyName)
                            .onSubmit {
                                focusedTextField = .companyName
                            }
                            .submitLabel(.next)

                        TextField("Company name", text: $viewModel.companyName)
                            .focused($focusedTextField, equals: .companyName)
                            .textContentType(.organizationName)
                            .onSubmit {
                                focusedTextField = .bio
                            }
                            .submitLabel(.next)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        CaractersRemainView(currentCount: viewModel.bio.count)
                            .accessibilityAddTraits(.isHeader)

                        Spacer()

                        if viewModel.isCheckedIn {
                            Button {
                                viewModel.checkOut()
                            } label: {
                                CheckOutButton()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }

                    BioTextEditor(text: $viewModel.bio)
                        .focused($focusedTextField, equals: .bio)
                }
                .padding(.horizontal, 20)

                Spacer()

                Button {
                    viewModel.determineButtonAction()
                } label: {
                    DDGButton(title: viewModel.buttonTitle)
                }
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Dismiss") {
                        focusedTextField = nil
                    }
                }
            }

            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .ignoresSafeArea(.keyboard)
        .task {
            await viewModel.getProfile()
            await viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

fileprivate struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

fileprivate struct ProfileImageView: View {
    var viewModel: ProfileView.ProfileViewModel
    @State private var selectedImage: PhotosPickerItem?

    var body: some View {
        ZStack(alignment: .bottom) {
            AvatarView(image: viewModel.avatar, size: 84)

            PhotosPicker(selection: $selectedImage, matching: .images) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
                    .padding(.bottom, 6)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Opens the iPhone's photo picker"))
        .padding(.leading, 12)
        .onChange(of: selectedImage) { _, _ in
            Task {
                if
                    let pickerItem = selectedImage,
                    let data = try? await pickerItem.loadTransferable(type: Data.self),
                    let image = UIImage(data: data)
                {
                    viewModel.avatar = image
                }
            }
        }
    }
}

fileprivate struct CaractersRemainView: View {
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

struct CheckOutButton: View {
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(10)
            .frame(height: 28)
            .background(Color.grubRed)
            .cornerRadius(8)
            .accessibilityLabel(Text("Check out of current location"))
    }
}

struct BioTextEditor: View {
    var text: Binding<String>

    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.secondary, lineWidth: 1)
            }
            .accessibilityLabel(Text("Bio"))
            .accessibilityHint(Text("This textfield has a 100 character limit."))
    }
}
