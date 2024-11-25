//
//  UserStore.swift
//  MayTrip
//
//  Created by 강승우 on 11/8/24.
//

import SwiftUI

final class UserStore {
    let DB = DBConnection.shared
    static let shared = UserStore()
    var user: User = User(id: 0, nickname: "", profileImage: nil, email: "", exp: 0, provider: "")
    
    func getUserInfo(email: String, provider: String) async throws -> Void {
        do {
            let result: [User] = try await DB.from("USER").select(
                """
                id,
                nickname,
                profile_image,
                email,
                exp,
                provider
                """
            )
                .eq("email", value: email)
                .eq("is_deleted", value: false)
                .execute().value
            if result.isEmpty {
                print("No data found for email \(email)")
                self.user = User(id: 0, nickname: "", profileImage: nil, email: email, exp: 0, provider: provider)
                return
            }
            self.user = result[0]
        } catch {
            print(error)
        }
    }
    
    func getUserInfo(id: Int) async throws -> User {
        var user: User = User(id: id, nickname: "", profileImage: nil, email: "", exp: 0, provider: "")
        do {
            let result: [User] = try await DB.from("USER").select(
                """
                id,
                nickname,
                profile_image,
                email,
                exp,
                provider
                """
            ).eq("id", value:id).execute().value
            if result.isEmpty {
                print("No data found for id \(id)")
                return user
            }
            user = result[0]
        } catch {
            print(error)
        }
        
        return user
    }
    
    func setUserInfo(nickname: String, image: UIImage?) async throws -> Void { // 나중에 프로필 이미지 수정해야함
        let userPost = UserPost(nickname: nickname, profileImage: "", email: self.user.email, provider: self.user.provider)
        
        do {
            try await DB.from("USER").insert(userPost).execute()
            try await self.getUserInfo(email: self.user.email, provider: self.user.provider)
        } catch {
            print(error)
        }
    }
    
    func updateProfileImage(_ image: String) async throws -> Void {
        do {
            try await DB
                .from("USER")
                .update(["profile_image":"\(image)"])
                .eq("id", value: user.id)
                .execute()
        } catch {
            print("failed to update profile image \(error)")
        }
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
        do {
            let result: [User] = try await DB.from("USER").select("id")
                .eq("nickname", value:nickname)
                .eq("is_deleted", value: false)
                .execute().value
            
            if result.isEmpty {
                return true
            }
            return false
        } catch {
            print(error)
            return false
        }
    }
    
    func resetUser() {
        user = User(id: 0, nickname: "", profileImage: nil, email: "", exp: 0, provider: "")
    }
    
    static func convertStringToImage(_ string: String?) -> UIImage? {
        if let string = string {
            if let data = Data(base64Encoded: string) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
