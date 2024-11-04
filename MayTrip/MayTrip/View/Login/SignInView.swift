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
    
    private var DB = DBConnection.shared
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkMaintainLogin: Bool = false
    @State private var isKeyboardVisible: Bool = false
    @FocusState private var focusField: Field?
    
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
                    
                    HStack { // 로그인 상태 유지
                        Button {
                            checkMaintainLogin.toggle()
                        } label: {
                            HStack(spacing: 4) {
                                if checkMaintainLogin {
                                    Image(systemName: "checkmark.square.fill")
                                } else {
                                    Image(systemName: "square")
                                        .foregroundStyle(.gray.opacity(0.7))
                                }
                                Text("로그인 상태 유지")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray.opacity(0.7))
                            }
                        }
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.9)
                    
                    VStack(spacing : 10) {
                        Button { // 로그인 버튼
                            if email.isEmpty {
                                
                            } else if password.isEmpty {
                                
                            } else {
                                Task {
                                    do {
                                        try await DB.auth.signOut()
                                        try await DB.auth.signIn (
                                            email: email,
                                            password: password
                                        )
                                        print("success")
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        } label : {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                Text("LOGIN")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.07)
                        
                        Button { // 게스트 로그인
                            
                        } label : {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 1)
                                Text("게스트 로그인")
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
                if isKeyboardVisible {
                    hideKeyboard()
                }
            }
            
            HStack(spacing : screenWidth * 0.08) {
                Button { // 애플 로그인
                    
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
                                try await DB.auth.signInWithIdToken(
                                    credentials: .init(
                                        provider: .apple,
                                        idToken: idToken
                                    )
                                )
                            } catch {
                                dump(error)
                            }
                        }
                    }
                    .blendMode(.overlay)
                }
                
                Button { // 구글 로그인
                    
                } label : {
                    ZStack {
                        Image("googleLogo")
                            .resizable()
                            .scaledToFit()
                    }
                    .clipShape(.circle)
                    .frame(width: screenWidth * 0.15)
                }
                
                Button { // 카카오 로그인
                    Task {
                        do {
                            try await DB.auth.signInWithOAuth(provider: .kakao, redirectTo: URL(string: "https://zmuqlogychbckqgfmzak.supabase.co/auth/v1/callback"))
                        } catch {
                            print(error)
                        }
                    }
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
        }
        .scrollDisabled(!isKeyboardVisible)
        .onAppear {
            email = ""
            password = ""
            // 키보드 이벤트 감지
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible = true
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    isKeyboardVisible = false
                }
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 옵저버 제거
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}
