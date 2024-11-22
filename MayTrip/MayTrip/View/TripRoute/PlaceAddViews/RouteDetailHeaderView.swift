//
//  RouteDetailHeaderView.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
//

import SwiftUI

struct RouteDetailHeaderView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @Environment(\.dismiss) var dismiss
    @Environment(ChatStore.self) private var chatStore: ChatStore
    @State var isScraped: Bool = false
    @State var showingDeleteAlert: Bool = false
    
    var tripRoute: TripRoute
    let dateStore: DateStore = DateStore.shared
    let userStore: UserStore = UserStore.shared
    
    var isWriter: Bool {
        tripRoute.writeUser.id == userStore.user.id
    }
    
    var body: some View {
        VStack {
            titleView
            cityTagsView
        }
        .alert("루트 삭제", isPresented: $showingDeleteAlert) {
            Button("취소", role: .cancel) {
                
            }
            Button("삭제", role: .destructive) {
                // 해당 루트 db에서 삭제 로직
                Task {
                    try await tripRouteStore.deleteTripRoute(routeId: tripRoute.id)
                    DispatchQueue.main.async {
                        navigationManager.popToRoot()
                    }
                }
            }
        } message: {
            Text("해당 루트를 삭제하시겠습니까?")
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTitle("여행루트")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dateStore.initDate()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                .foregroundStyle(.black)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    if isWriter {   // 루트 작성자일때 메뉴버튼
                        Button("편집하기") {
                            // TODO: 루트 편집으로 이동, 편집완료시 db에 업데이트 로직
                            navigationManager.push(.enterBasicInfo(tripRoute: tripRoute))
                        }
                        
                        Button("삭제하기", role: .destructive) {
                            showingDeleteAlert = true
                        }
                        
                    } else {    // 조회하는 사람일때 메뉴버튼
                        Button("채팅하기") {
                            // write유저와 채팅 연결
                            Task {
                                let user = try await userStore.getUserInfo(id: tripRoute.writeUser.id) // 게시글 작성자 정보 찾기
                                if try await chatStore.findChatRoom(user1: userStore.user.id, user2: tripRoute.writeUser.id) { // 이미 채팅방이 있는 경우
                                    
                                    navigationManager.selection = 2 // 채팅탭으로 이동
                                    navigationManager.popToRoot()
                                    DispatchQueue.main.async {
                                        if let enteredChatRoom = chatStore.enteredChatRoom {
                                            navigationManager.push(.chatRoom(enteredChatRoom, user))
                                        }
                                    }
                                } else {
                                    try await chatStore.saveChatRoom(tripRoute.writeUser.id) // 방 생성 후 채팅방 찾아서 이동
                                    
                                    navigationManager.selection = 2
                                    navigationManager.popToRoot()
                                    DispatchQueue.main.async {
                                        if let enteredChatRoom = chatStore.enteredChatRoom {
                                            navigationManager.push(.chatRoom(enteredChatRoom, user))
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button("신고하기", role: .destructive) {
                            // TODO: write유저 신고 로직
                        }
                        .foregroundStyle(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .foregroundStyle(.black)
            }
        }
    }
    
    var titleView: some View {
        HStack(alignment: .bottom) {
            Text(tripRoute.title)
                .font(.title)
                .bold()
        
            Spacer()
            
            Text("작성자: \(tripRoute.writeUser.nickname)")
                    .font(.footnote)
            
            if !isWriter {
                Button {
                    isScraped.toggle()
                } label: {
                    Image(systemName: isScraped ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }

    var cityTagsView: some View {
        HStack {
            VStack {
                CityTagFlowLayout(spacing: 10) {
                    ForEach(tripRoute.city, id: \.self) { city in
                        Text("# \(city)")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(Color(UIColor.darkGray))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}
