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
    @Published var user: User = User(id: 0, nickname: "", profileImage: nil, email: "", exp: 0, provider: "")
    
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
            ).eq("email", value:email).execute().value
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
    
    func setUserInfo(nickname: String, image: UIImage?) async throws -> Void { // 나중에 프로필 이미지 수정해야함
        let userPost = UserPost(nickname: nickname, profileImage: "", email: self.user.email, provider: self.user.provider)
        
        do {
            try await DB.from("USER").insert(userPost).execute()
            try await self.getUserInfo(email: self.user.email, provider: self.user.provider)
        } catch {
            print(error)
        }
    }
}
