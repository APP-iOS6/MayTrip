//
//  MyPageView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct MyPageView: View {
    @Environment(AuthStore.self) var authStore: AuthStore
    @State var isShowingLogoutAlert: Bool = false
    @State var isShowingSignOutAlert: Bool = false
    let userStore = UserStore.shared
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    VStack(alignment: .center, spacing: proxy.size.height * 0.04) {
                        VStack(spacing: proxy.size.height * 0.02) { // 프로필
                            if userStore.user.profileImage == "" {
                                ZStack {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: proxy.size.width * 0.15, height: proxy.size.width * 0.15)
                                        .foregroundStyle(Color.accent)
                                        .padding(20)
                                        .background {
                                            Circle()
                                                .foregroundStyle(Color.accent.opacity(0.6))
                                        }
                                }
                            } else {
                                ZStack { // 나중에 유저 이미지 추가되면 수정
                                    
                                }
                            }
                            
                            Text("\(userStore.user.nickname)")
                                .font(.title)
                        }
                        .padding(.top, proxy.size.height * 0.05)
                        
                        HStack(spacing: proxy.size.width * 0.2) {
                            Button {
                                
                            } label: {
                                manageButtonLabel(image:"mappin.and.ellipse", text:"루트 관리", width: proxy.size.width)
                            }
                            
                            Button {
                                
                            } label: {
                                manageButtonLabel(image:"pencil.and.list.clipboard", text:"게시글 관리", width: proxy.size.width)
                            }
                        }
                        
                        Rectangle()
                            .frame(width: proxy.size.width, height: proxy.size.height * 0.01)
                            .foregroundStyle(Color(uiColor: .systemGray6))
                        
                        // 이 부분에 추후에 뭔가 추가해야 함
                        
                        listView()
                        
                        Spacer()
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("고객센터")
                .padding(.vertical, 5)
            
            Divider()
            
            Text("알림")
                .padding(.vertical, 5)
            
            Divider()
            
            Text("설정")
                .padding(.vertical, 5)
            
            Divider()
            
            Button {
                isShowingLogoutAlert = true
                
            } label :{
                HStack {
                    Text("로그아웃")
                        .padding(.vertical, 5)
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .alert("정말 로그아웃 하시겠습니까?", isPresented: $isShowingLogoutAlert) {
                Button("취소", role: .cancel) {
                    isShowingLogoutAlert = false
                }
                Button("로그아웃", role: .destructive) {
                    isShowingLogoutAlert = false
                    Task {
                        try await authStore.signOut()
                    }
                }
            }
            
            Divider()
            
            Button {
                isShowingSignOutAlert = true
            } label :{
                HStack {
                    Text("회원탈퇴")
                        .padding(.vertical, 5)
                        .foregroundStyle(.red.opacity(1))
                    Spacer()
                }
            }
            .alert("정말 회원탈퇴 하시겠습니까?", isPresented: $isShowingSignOutAlert) {
                Button("취소", role: .cancel) {
                    isShowingSignOutAlert = false
                }
                Button("회원탈퇴", role: .destructive) {
                    isShowingSignOutAlert = false
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MyPageView()
}
