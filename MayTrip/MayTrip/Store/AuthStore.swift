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
import Supabase

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
    
    func signOut() async throws {
        let provider = userStore.user.provider
        
        do {
            switch provider {
            case "google":
                GIDSignIn.sharedInstance.signOut()
                print("google logout success")
                self.isLogin = false
            case "kakao":
                UserApi.shared.logout {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("kakao logout success.")
                        self.isLogin = false
                    }
                }
            default: // 이메일, 애플 로그인 경우 Supabase
                try await DB.auth.signOut()
                print("email, apple logout success")
                self.isLogin = false
            }
        } catch {
            print(error)
        }
    }
    
    func checkAutoLogin() async {
        Task {
            //            try await DB.auth.signOut()
            try await checkSupabaseLogin()
        }
    }
    
    func checkSupabaseLogin() async { // 이메일, 애플
        do {
            let user = try await DB.auth.user()
            let provider = user.appMetadata["provider"]!
            guard let providerJSON = try? JSONEncoder().encode(provider), let providerString = String(data: providerJSON, encoding: .utf8) else {
                return
            }
            await successLogin(email: user.email!, provider: providerString)
            print(user.email!, providerString)
        } catch {
            print(error)
        }
    }
}
