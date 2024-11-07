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
    @Published var nickname: String = ""
    @Published var profileImage: UIImage?
    
    init() {
        kakaoInit()
    }
    
    func successLogin() {
        self.isLogin = true
    }
    
    func updateProfile(nickname: String, image: UIImage?) {
        if let image = image {
            profileImage = image
        }
        
        self.nickname = nickname
    }
    
    func kakaoInit() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? "" // 이놈이 먹통임
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    let url : String = "https://kapi.kakao.com/v1/user/access_token_info"
                    AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: ["Authorization" : "Bearer \(oauthToken!.accessToken)"]).responseJSON() { response in
                                                switch response.result {
                                                case .success:
                                                    if let data = try! response.result.get() as? [String: Any] {
                                                        self.successLogin()
                                                        print(data["app_id"])
                                                        print(data["id"]!) // 카카오 고유 id
                                                    }
                                                case .failure(let error):
                                                    print("Error: \(error)")
                                                }
                                            }
                }
            }
        } else { // 카카오톡이 설치가 안되어 있을 경우
            // 카카오 계정으로 로그인 하기 - 웹뷰를 열러서 로그인 하기
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    let url : String = "https://kapi.kakao.com/v1/user/access_token_info"
                    AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: ["Authorization" : "Bearer \(oauthToken!.accessToken)"]).responseJSON() { response in
                                                switch response.result {
                                                case .success:
                                                    if let data = try! response.result.get() as? [String: Any] {
                                                        self.successLogin()
                                                        print(data["app_id"])
                                                        print(data["id"]!) // 카카오 고유 id
                                                        print("---------------------------")
                                                        print(data)
                                                    }
                                                case .failure(let error):
                                                    print("Error: \(error)")
                                                }
                                            }
                }
            }
        }
    }
    
    func googleLogin() {
        guard let presentingViewController  = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else { return }
            
            guard let profile = result.user.profile else { return }
            print(profile.email)
            self.successLogin()
        }
    }
}
