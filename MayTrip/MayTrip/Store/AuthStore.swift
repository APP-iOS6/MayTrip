//
//  AuthStore.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI
import GoogleSignIn
import Auth
import KakaoSDKCommon
import KakaoSDKUser
import Alamofire

class AuthStore: ObservableObject {
    let DB = DBConnection.shared
    @Published var isLogin: Bool = false
    @Published var user: User = User(id: 0, nickname: "", profileImage: nil, email: "", exp: 0, provider: "")
    var email: String = ""
    var provider: String = ""
    @Published var nickname: String = ""
    @Published var profileImage: UIImage?
    @Published var isFirstLogin: Bool = true
    
    init() {
        kakaoInit()
    }
    
    @MainActor
    func successLogin(email: String, provider: String) async {
        self.email = email
        self.provider = provider
        do {
            try await getUserInfo(email: email)
            self.isLogin = true
        } catch {
            print("Failed to fetch user info: \(error)")
        }
    }
    
    @MainActor
    func getUserInfo(email: String) async throws -> Void {
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
                user = User(id: 0, nickname: "", profileImage: nil, email: email, exp: 0, provider: "")
                return
            }
            user = result[0]
            isFirstLogin = false
        } catch {
            print(error)
        }
    }
    
    func setUserInfo(nickname: String, image: UIImage?) async throws -> Void {
        var userPost = UserPost(nickname: nickname, profileImage: "", email: user.email, provider: self.provider)
        
        do {
            try await DB.from("USER").insert(userPost).execute()
            try await getUserInfo(email: user.email)
        } catch {
            print(error)
        }
    }
}
