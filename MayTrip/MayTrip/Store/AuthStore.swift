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
            } else {
                isFirstLogin = true
            }
            self.isLogin = true
            print(userStore.user.email, userStore.user.provider)
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
            case "email", "apple": // 이메일, 애플 로그인 경우 Supabase
                try await DB.auth.signOut()
                print("email, apple logout success")
                self.isLogin = false
            default :
                print("not logined")
            }
        } catch {
            print(error)
        }
    }
    
    func checkAutoLogin() async { // 토큰 확인 후 유효하면 자동 로그인
        Task {
            if await checkSupabaseLogin() { // 수파베이스(이메일, 애플)
                return
            } else if checkGoogleLogin() { // 구글
                return
            } else {
                checkKakaoLogin() // 카카오
            }
        }
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
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
            ).eq("nickname", value:nickname).execute().value
            
            if result.isEmpty {
                return true
            }
            return false
        } catch {
            print(error)
            return false
        }
    }
    
    func checkSupabaseLogin() async -> Bool { // 이메일, 애플
        do {
            let user = try await DB.auth.user()
            let provider = user.appMetadata["provider"]!
            guard let providerJSON = try? JSONEncoder().encode(provider), let providerString = String(data: providerJSON, encoding: .utf8) else {
                return false
            } // jsonString이 provider가 아닌 "provider"로 반환되서 삼항연산자를 통해 처리
            await successLogin(email: user.email!, provider: providerString == "\"email\"" ? "email" : "apple")
            return true
        } catch {
            print(error)
            return false
        }
    }
}
