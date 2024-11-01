//
//  SignUpView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isSignUp: Bool
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var errorMessage: String = ""
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: screenHeight * 0.02) {
            
            // 이메일 입력
            CreateLoginViewTextField(text: $email, symbolName: "", placeholder: "이메일을 입력해주세요", width: screenWidth * 0.9, height: screenHeight * 0.06, isSecure: false)
            
            // 비밀번호 입력
            CreateLoginViewTextField(text: $password, symbolName: "", placeholder: "영문 + 숫자 6자리 이상 입력해주세요", width: screenWidth * 0.9, height: screenHeight * 0.06, isSecure: true)
            
            // 비밀번호 확인
            CreateLoginViewTextField(text: $confirmPassword, symbolName: "", placeholder: "비밀번호를 다시 한 번 입력해주세요", width: screenWidth * 0.9, height: screenHeight * 0.06, isSecure: true)
            
            if !errorMessage.isEmpty {
                HStack {
                    Text(errorMessage)
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
            
            
            VStack(spacing : 10) {
                Button { // 회원가입
                    
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                        Text("회원가입")
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                
                HStack(spacing:3) {
                    Text("이미 계정이 있으신가요?")
                        .foregroundStyle(.gray.opacity(0.7))
                    
                    Button {
                        isSignUp.toggle()
                    } label : {
                        Text("로그인")
                            .foregroundStyle(.accent)
                    }
                }
            }
            .frame(width: screenWidth * 0.9, height: screenHeight * 0.1)
            .padding(.bottom, screenHeight * 0.15)
        }
    }
}
