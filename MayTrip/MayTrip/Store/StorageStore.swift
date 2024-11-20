//
//  StorageStore.swift
//  MayTrip
//
//  Created by 강승우 on 11/20/24.
//

import SwiftUI

class StorageStore {
    let DB = DBConnection.shared
    let userStore = UserStore.shared
    static let shared = StorageStore()
    
    func uploadImage(images: [UIImage]) async throws -> [String] {
        var names: [String] = []
        
        for image in images {
            let fileName = "\(Int(Date().timeIntervalSince1970))" + "_" + UUID().uuidString
            let path = "\(userStore.user.email)/\(fileName).jpg"
            let data = image.jpegData(compressionQuality: 0.5)
            
            
            if let data = data {
                do {
                    try await DB.storage
                        .from("post_image")
                        .upload(
                            "public/\(path)",
                            data: data
                        )
                    names.append("public/\(path)")
                } catch {
                    print(error)
                }
            }
        }
        return names
    }
    
    func getImages(pathes: [String]) async throws -> [UIImage] {
        var images: [UIImage] = []
        do {
            for path in pathes {
                let imageData = try await DB.storage.from("post_image").download(path: path)
                if let image = UIImage(data: imageData){
                    images.append(image)
                }
            }
        } catch {
            print(error)
        }
        
        return images
    }
}
