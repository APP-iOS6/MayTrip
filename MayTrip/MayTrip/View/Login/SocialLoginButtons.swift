//
//  LoginButtons.swift
//  MayTrip
//
//  Created by 강승우 on 11/5/24.
//

import SwiftUI
import AuthenticationServices

extension SignInView {
    
    @ViewBuilder // 카카오 로그인
    func kakaoLoginButton() -> some View {
        Button {
            authStore.kakaoLogin()
        } label : {
            ZStack {
                Circle()
                    .foregroundStyle(Color(red: 254/255, green: 229/255, blue: 0))
                    .frame(width: screenWidth * 0.15)
                Image("kakaoLogo")
            }
            .clipShape(.circle)
            .frame(width: screenWidth * 0.15)
        }
    }
    
    @ViewBuilder // 구글 로그인
    func googleLoginButton() -> some View {
        Button {
            authStore.googleLogin()
        } label : {
            Image("googleLogo")
                .resizable()
                .scaledToFill()
                .clipShape(.circle)
                .frame(width: screenWidth * 0.15, height: screenWidth * 0.15)
        }
    }
    
    @ViewBuilder // 애플 로그인
    func appleLoginButton() -> some View {
        HStack(spacing : screenWidth * 0.08) {
            Button {
                appleLoginManager.startSignInWithAppleFlow { result in
                    Task {
                        switch result {
                        case .success(let appleResult):
                            try await authStore.appleLogin(idToken: appleResult.idToken, nonce: appleResult.nonce)
                        case .failure(_):
                            print("error")
                        }
                    }
                }
            } label : {
                Image("appleLogo")
                    .resizable()
                    .scaledToFill()
                    .clipShape(.circle)
                    .frame(width: screenWidth * 0.15)
                    .overlay {
                        Circle()
                            .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
                    }
                
            }
        }
    }
    
}
