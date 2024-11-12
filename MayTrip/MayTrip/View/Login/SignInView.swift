//
//  SignInView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI
import AuthenticationServices
import Supabase

struct SignInView : View {
    enum Field : Hashable{
        case email
        case password
    }
    
    @Environment(AuthStore.self) var authStore: AuthStore
    let userStore = UserStore.shared
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkMaintainLogin: Bool = false
    @FocusState private var focusField: Field?
    @State var errorMessage: String = ""
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body : some View {
        ScrollView {
            VStack {
                VStack {
                    Image("appIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.3)
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.3)
                }
                .padding(.top, screenHeight * 0.08)
                .padding(.bottom, screenHeight * 0.1)
                
                
                VStack(spacing: screenHeight * 0.02) {
                    
                    // 이메일 입력
                    CreateLoginViewTextField(text: $email, symbolName: "person", placeholder: "이메일 입력", width: screenWidth * 0.9, height: screenHeight * 0.07, isSecure: false, isFocused: focusField == .email)
                        .focused($focusField, equals: .email)
                    
                    // 비밀번호 입력
                    CreateLoginViewTextField(text: $password, symbolName: "lock", placeholder: "비밀번호 입력", width: screenWidth * 0.9, height: screenHeight * 0.07, isSecure: true, isFocused: focusField == .password)
                        .focused($focusField, equals: .password)
                    
                    HStack {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .font(.system(size: 14))
                    .frame(width: screenWidth * 0.9)
                    
                    
                    VStack(spacing : 10) {
                        Button { // 로그인 버튼
                            if email.isEmpty {
                                errorMessage = "이메일을 입력해주세요"
                            } else if password.isEmpty {
                                errorMessage = "비밀번호를 입력해주세요"
                            } else {
                                Task {
                                    do {
                                        try await authStore.DB.auth.signOut()
                                        try await authStore.DB.auth.signIn (
                                            email: email,
                                            password: password
                                        )
                                        Task {
                                            await authStore.successLogin(email: email, provider: "email")
                                        }
                                    } catch {
                                        errorMessage = "이메일 또는 비밀번호를 확인해주세요"
                                        print(error)
                                    }
                                }
                            }
                        } label : {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.accent)
                                Text("LOGIN")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.07)
                        
                        Button { // 게스트 로그인
                            
                        } label : {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.accent, lineWidth: 1)
                                Text("게스트 로그인")
                                    .foregroundStyle(Color.accent)
                            }
                        }
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.07)
                        
                        HStack {
                            Text("계정이 없으신가요?")
                                .foregroundStyle(.gray.opacity(0.7))
                            NavigationLink{
                                SignUpView()
                            } label : {
                                Text("회원가입")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .padding(.bottom, screenHeight * 0.03)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusField = nil
            }
            
            HStack(spacing : screenWidth * 0.08) {
                appleLoginButton()
                
                googleLoginButton()
                
                kakaoLoginButton()
            }
        }
        .scrollDisabled(focusField == nil)
        .onAppear {
            email = ""
            password = ""
            errorMessage = ""
            
            Task {
                try await authStore.checkAutoLogin()
            }
        }
    }
}
