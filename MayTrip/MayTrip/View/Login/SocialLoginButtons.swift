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
            ZStack {
                Image("googleLogo")
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(.circle)
            .frame(width: screenWidth * 0.15)
        }
    }
    
    @ViewBuilder // 애플 로그인
    func appleLoginButton() -> some View {
        HStack(spacing : screenWidth * 0.08) {
            Button {
                
            } label : {
                ZStack {
                    Circle()
                        .stroke(.black, lineWidth: 1)
                    Image("appleLogo")
                        .resizable()
                        .scaledToFit()
                }
                .clipShape(.circle)
                .frame(width: screenWidth * 0.15)
                
            }
            .overlay {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    Task {
                        do {
                            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                            else {
                                return
                            }
                            
                            guard let idToken = credential.identityToken
                                .flatMap({ String(data: $0, encoding: .utf8) })
                            else {
                                return
                            }
                            try await authStore.DB.auth.signInWithIdToken(
                                credentials: .init(
                                    provider: .apple,
                                    idToken: idToken
                                )
                            )
                            
                            Task {
                                let user = try await authStore.DB.auth.user()
                                await authStore.successLogin(email: user.email!, provider: "apple")
                            }
                        } catch {
                            dump(error)
                        }
                    }
                }
                .blendMode(.overlay)
            }
        }
    }
    
}
