//
//  AuthStore+Kakao.swift
//  MayTrip
//
//  Created by 강승우 on 11/7/24.
//

import SwiftUI
import Auth
import KakaoSDKCommon
import KakaoSDKUser
import Alamofire


extension AuthStore {
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
                                    Task {
                                        await self.successLogin(email: String(format: "%@", data["id"] as! CVarArg), provider: "kakao")
                                    }
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
                                    Task {
                                        await self.successLogin(email: String(format: "%@", data["id"] as! CVarArg), provider: "kakao")
                                    }
                                }
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    }
            }
        }
    }
    
    func checkKakaoLogin() -> Bool {
        var isSuccess: Bool = false
        UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
            if let error = error {
                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  { // 추후 추가예정
                    //로그인 필요
                }
                else {
                    //기타 에러
                }
            }
            else {
                Task {
                    await self.successLogin(email: String((accessTokenInfo?.id!)!), provider: "kakao")
                }
                isSuccess = true
            }
        }
        return isSuccess
    }
}
