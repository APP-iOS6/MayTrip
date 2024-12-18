//
//  SignUpView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct SignUpView: View {
    enum Field : Hashable{
        case email
        case password
        case confirmPassword
    }
    
    private var DB = DBConnection.shared
    @Environment(\.dismiss) var dismiss
    @Environment(AuthStore.self) var authStore
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @FocusState private var focusField: Field?
    @State private var isHidePassword: Bool = true
    @State private var isHideConfirmPassword: Bool = true
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: screenHeight * 0.025) {
                // 이메일 입력
                HStack(spacing: 5) {
                    Text("이메일")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(uiColor: .systemGray))
                        .frame(width: screenWidth * 0.15, height: screenHeight * 0.06, alignment: .leading)
                    
                    CreateLoginViewTextField(text: $email, symbolName: "", placeholder: "이메일을 입력해주세요", width: screenWidth * 0.75, height: screenHeight * 0.06, isSecure: false, isFocused: focusField == .email, isEmail: true)
                        .focused($focusField, equals: .email)
                }
                .padding(.top, screenHeight * 0.05)
                
                // 비밀번호 입력
                ZStack {
                    HStack(spacing:5) {
                        Text("비밀번호")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(uiColor: .systemGray))
                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.06, alignment: .leading)
                        
                        CreateLoginViewTextField(text: $password, symbolName: "", placeholder: "비밀번호(6자 이상 영문자+숫자)", width: screenWidth * 0.75, height: screenHeight * 0.06, isSecure: isHidePassword, isFocused: focusField == .password, isEmail: false)
                            .focused($focusField, equals: .password)
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            isHidePassword.toggle()
                        } label: {
                            Image(systemName: isHidePassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color(uiColor: .systemGray2))
                                .padding(.trailing, screenWidth * 0.02)
                        }
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                }
                
                ZStack {
                    HStack(spacing:5) {
                        Text("")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(uiColor: .systemGray))
                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.06, alignment: .leading)
                        // 비밀번호 확인
                        CreateLoginViewTextField(text: $confirmPassword, symbolName: "", placeholder: "비밀번호를 다시 한 번 입력해주세요", width: screenWidth * 0.75, height: screenHeight * 0.06, isSecure: isHideConfirmPassword, isFocused: focusField == .confirmPassword, isEmail: false)
                            .focused($focusField, equals: .confirmPassword)
                    }
                    HStack {
                        Spacer()
                        Button {
                            isHideConfirmPassword.toggle()
                        } label: {
                            Image(systemName: isHideConfirmPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color(uiColor: .systemGray2))
                                .padding(.trailing, screenWidth * 0.02)
                        }
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                }
                .padding(.bottom, -25)
                
                if !errorMessage.isEmpty {
                    HStack(spacing:5) {
                        Text("")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(uiColor: .systemGray))
                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.06, alignment: .leading)
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.04)
                } else {
                    HStack {
                        Text("spacer")
                            .foregroundStyle(.red)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.04)
                    .opacity(0.0001)
                }
                
                Button { // 회원가입
                    Task {
                        if checkValid() {
                            Task {
                                do {
                                    try await DB.auth.signUp(
                                        email: email,
                                        password: password
                                    )
                                    
                                    try await DB.auth.signIn(
                                        email: email,
                                        password: password
                                    )
                                    
                                    Task {
                                        await authStore.successLogin(email: email, provider: "email")
                                    }
                                } catch {
                                    errorMessage = "이미 가입된 이메일입니다"
                                    print(error)
                                }
                            }
                        }
                    }
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle((email.isEmpty || password.isEmpty || confirmPassword.isEmpty) ? .gray : .accent)
                        Text("회원가입")
                            .foregroundStyle(.white)
                    }
                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                }
                .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                .padding(.top, screenHeight * 0.32)
                .padding(.bottom, screenHeight * 0.05)
            }
        }
        .scrollDisabled(focusField == nil)
        .onTapGesture {
            focusField = nil
        }
        .onAppear {
            email = ""
            password = ""
            errorMessage = ""
        }
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.automatic)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label : {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }
}

extension SignUpView {
    func checkValid() -> Bool {
        if password.count < 6 {
            errorMessage = "6글자 이상의 비밀번호를 입력해주세요"
            return false
        } else if confirmPassword != password {
            errorMessage = "비밀번호를 확인해주세요"
            return false
        } else if !checkContainSpecailCharacter(){
            errorMessage = "사용 불가능한 문자가 포함되어 있습니다"
            return false
        }
        
        return true
    }

    func checkContainSpecailCharacter() -> Bool {
        do {
            let pattern = "^[a-zA-Z0-9]"
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: password.count)
            return regex.firstMatch(in: password, options: [], range: range) != nil
        } catch {
            return false
        }
    }
}

