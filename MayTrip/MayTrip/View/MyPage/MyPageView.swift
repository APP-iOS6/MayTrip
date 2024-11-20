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
                    VStack(alignment: .leading) {
                        HStack {
                            if let image = userStore.user.profileImage, image != "" {
                                // TODO: 이미지 띄우기
                                Image(systemName: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Button {
                                    // TODO: 이미지 변경하는 로직 추가
                                } label: {
                                    ZStack {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(5)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .foregroundStyle(Color("accentColor").opacity(0.2))
                                        
                                        VStack(alignment: .trailing) {
                                            Spacer()
                                            HStack(alignment: .top) {
                                                Spacer()
                                                
                                                Image(systemName: "pencil.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                .frame(width: 60, height: 60)
                            }
                            
                            Text("\(userStore.user.nickname)")
                                .font(.title3)
                                .padding(.horizontal, 10)
                        }
                        .padding()
                        
                        List {
                            Section("개인") {
                                NavigationLink {
                                    
                                } label: {
                                    Text("여행 관리")
                                }
                                
                                NavigationLink {
                                    
                                } label: {
                                    Text("게시물 관리")
                                }
                            }
                            
                            Section("계정") {
                                Button {
                                    isShowingLogoutAlert = true
                                } label: {
                                    Text("로그아웃")
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
                                
                                Button {
                                    isShowingSignOutAlert = true
                                } label: {
                                    Text("회원탈퇴")
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
                            
                            Section("고객센터") {
                                NavigationLink {
                                    
                                } label: {
                                    Text("문의하기")
                                }
                                
                                NavigationLink {
                                    
                                } label: {
                                    Text("공지사항")
                                }
                            }
                            
                            Section("앱 정보") {
                                HStack {
                                    Text("앱 버전")
                                    
                                    Spacer()
                                    
                                    Text("v 0.0.1")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .listStyle(.plain)
                        
                        Spacer()
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

#Preview {
    MyPageView()
}
