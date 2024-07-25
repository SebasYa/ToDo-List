//
//  ProfileView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    // Images Properties
    @State private var isShowingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var profileImageData: Data? = nil
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    HStack {
                        Text("Loading profile...")
                            .font(.title3)
                        Image(systemName: String("arrow.circlepath"))
                            .foregroundStyle(.green)
                            .bold()
                    }
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            // Fetch user and profile image only if user or profile image is nil
            if viewModel.user == nil || viewModel.profileImage == nil {
                viewModel.fetchUserAndProfileImage()
            }
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        VStack {
            // image comprobation
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.blue, lineWidth: 1))
                    .shadow(radius: 5)
                    .padding()
            } else {
                Image(systemName: String("person.circle"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.blue)
                    .frame(width: 150, height: 150)
                    .padding()
            }
            Button("Select Image") {
                isShowingPhotoPicker = true
            }
            .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
            .onChange(of: selectedPhotoItem) { oldItem, newItem in
                Task {
                    if let unwrappedNewItem = newItem {
                        do {
                            if let imageData = try await unwrappedNewItem.loadTransferable(type: Data.self) {
                                viewModel.uploadImageToFirebase(imageData: imageData)
                            }
                        } catch {
                            print("Error loading transfer Image: \(error)")
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Name:")
                    Text(user.name)
                }
                .padding()
                
                HStack {
                    Text("Email:")
                    Text(user.email)
                }
                .padding()
                
                HStack {
                    Text("Member Since:")
                    Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                }
                .padding()
            }
            
            TLButton(title: "Log Out", background: .red) {
                viewModel.logout()
            }
            .padding(.top, 140)
        }
    }
}

#Preview("English") {
    ProfileView()
        .environment(\.locale, Locale(identifier: "EN"))
}
#Preview("Español") {
    ProfileView()
        .environment(\.locale, Locale(identifier: "ES"))
}
