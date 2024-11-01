//
//  SignInView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct SignInView : View {
    @Binding var isSignUp: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkMaintainLogin: Bool = false
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body : some View {
        VStack(spacing: screenHeight * 0.02) {
            
            // 이메일 입력
            CreateLoginViewTextField(text: $email, symbolName: "person", placeholder: "이메일 입력", width: screenWidth * 0.9, height: screenHeight * 0.06, isSecure: false)
            
            // 비밀번호 입력
            CreateLoginViewTextField(text: $password, symbolName: "lock", placeholder: "비밀번호 입력", width: screenWidth * 0.9, height: screenHeight * 0.06, isSecure: true)
            
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
                    
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                        Text("LOGIN")
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                
                Button { // 게스트 로그인
                    
                } label : {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                        Text("게스트 로그인")
                    }
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.06)
                
                HStack {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(.gray.opacity(0.7))
                    Button {
                        isSignUp.toggle()
                    } label : {
                        Text("회원가입")
                            .foregroundStyle(.accent)
                    }
                }
            }
            .padding(.bottom, screenHeight * 0.03)
            
            
            
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
    }
}
