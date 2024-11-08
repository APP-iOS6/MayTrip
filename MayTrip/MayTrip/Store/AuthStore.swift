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

@Observable
class AuthStore {
    let DB = DBConnection.shared
    let userStore = UserStore.shared
    
    var isLogin: Bool = false
    var isFirstLogin = true
    
    init() {
        kakaoInit()
    }
    
    @MainActor
    func successLogin(email: String, provider: String) async {
        self.userStore.user = User(id: 0, nickname: "", profileImage: nil, email: email, exp: 0, provider: provider)
        do {
            try await self.userStore.getUserInfo(email: email, provider: provider)
            if !self.userStore.user.nickname.isEmpty {
                isFirstLogin = false
            }
            self.isLogin = true
        } catch {
            print("Failed to fetch user info: \(error)")
        }
    }
}
