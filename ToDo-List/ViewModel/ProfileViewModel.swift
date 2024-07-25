//
//  ProfileViewModel.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ProfileViewModel: ObservableObject {
    
    @Published var user: User? = nil
    @Published var profileImage: UIImage? = nil
    
    private let storageRef = Storage.storage().reference()
    private var currentDownloadTask: StorageDownloadTask?
    private var currentUploadTask: StorageUploadTask?
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
        // MARK: - User
    
    func fetchUser() {
        guard let userId = self.userId else {
            return
        }
        
        let dataBase = Firestore.firestore()
        
        dataBase.collection(String("users")).document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data[String("id")] as? String ?? "",
                    name: data[String("name")] as? String ?? "",
                    email: data[String("email")] as? String ?? "",
                    joined: data[String("joined")] as? TimeInterval ?? 0,
                    profileImageUrl: data[String("profileImageUrl")] as? String ?? ""
                )
                
                // Load image if url exist
                if let profileImageUrl = self?.user?.profileImageUrl, !profileImageUrl.isEmpty {
                    DispatchQueue.main.async {
                        self?.loadProfileImage(url: profileImageUrl)
                    }
                }
            }
        }
    }
    
    func fetchUserAndProfileImage() {
        fetchUser()
    }
    
    
    // MARK: - Profile Image
    func loadProfileImage(url: String) {
        guard let userId = self.userId else {
            return
        }
        
        // Cancel any ongoing image download task
        cancelCurrentDownloadTask()
        
        // Set profileImage to nil to avoid displaying old image while downloading new one
        DispatchQueue.main.async {
            self.profileImage = nil
        }
        
        let localURL = localImageURL(for: userId)
        
        // Check if the image exists locally
        if FileManager.default.fileExists(atPath: localURL.path) {
            if let localImage = UIImage(contentsOfFile: localURL.path) {
                DispatchQueue.main.async {
                    self.profileImage = localImage
                    print("Loaded image from local storage \(localURL.path)")
                }
            }
        } else {
        
        let userImageRef = storageRef.child("\(userId)").child(String("ProfileImage.jpg"))
            currentDownloadTask = userImageRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
                self?.currentDownloadTask = nil
                
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("No data or unable to create image")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.profileImage = image
                    print("Load image from Firebase")
                    // Save the image localy
                    self?.saveImageLocally(image: image, for: userId)
                }
            }
        }
    }
    
     // Save locally (document directory)
    
    func saveImageLocally(image: UIImage, for userId: String) {
            // First, delete the old image
            deleteLocalImage(for: userId)
            
            // Now, save the new image
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            let localURL = localImageURL(for: userId)
            
            do {
                try data.write(to: localURL)
                print("Saved image to local storage: \(localURL.path)")
            } catch {
                print("Error saving image to local storage: \(error.localizedDescription)")
            }
        }
    
    // Delete locally (document directory)
    func deleteLocalImage(for userId: String) {
            let localURL = localImageURL(for: userId)
            if FileManager.default.fileExists(atPath: localURL.path) {
                do {
                    try FileManager.default.removeItem(at: localURL)
                    print("Deleted old image from local storage")
                } catch {
                    print("Error deleting old image from local storage: \(error.localizedDescription)")
                }
            }
        }

    // MARK: - Firebase Storage Image
    
    func uploadImageToFirebase(imageData: Data) {
        guard let userId = self.userId else {
            return
        }
        // Cancel any ongoing image upload task before uploading a new image
        cancelCurrentUploadTask()
        
        DispatchQueue.main.async {
            self.profileImage = UIImage(data: imageData)
        }
        
        let userImageRef = storageRef.child("\(userId)").child(String("ProfileImage.jpg"))
        
        // Upload new image to Firebase Storage
        currentUploadTask = userImageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            self.currentUploadTask = nil
            
            if let error = error {
                print("Error checking image metadata: \(error.localizedDescription)")
                return
            }
            
            let localURL = self.localImageURL(for: userId)
            do {
                try imageData.write(to: localURL)
                print("Upload image and saved locally")
            } catch {
                print("Error saving uploaded image locally: \(error.localizedDescription)")
            }
        }
        
        currentUploadTask?.observe(.progress) { snapshot in
            let percentComplete = Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 1)
            DispatchQueue.main.async {
                print("Upload is \(percentComplete * 100)% complete")
            }
        }
        currentUploadTask?.observe(.success) { snapshot in
            print("Upload complete successfully")
        }
        currentUploadTask?.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Upload failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func localImageURL(for userId: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("Documents Directory: \(documentsDirectory.path)")
        return documentsDirectory.appendingPathComponent("ProfileImage.jpg")
        
    }
    
    private func cancelCurrentDownloadTask() {
        currentDownloadTask?.cancel()
        currentDownloadTask = nil
    }
    
    private func cancelCurrentUploadTask() {
        currentUploadTask?.cancel()
        currentUploadTask = nil
    }
}
