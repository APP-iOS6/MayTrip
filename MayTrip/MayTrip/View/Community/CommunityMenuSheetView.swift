//
//  CommunityMenuSheetView.swift
//  MayTrip
//
//  Created by 강승우 on 11/18/24.
//

import SwiftUI
struct CommunityMenuSheetView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(ChatStore.self) private var chatStore: ChatStore
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @Binding var isPresented: Bool
    @State var isPresentedDeleteAlert: Bool = false
    
    let userStore = UserStore.shared
    
    var body: some View {
        if userStore.user.id == communityStore.selectedPost.author.id { // 제작자의 경우
            List {
                Button {
                    // 게시글 편집
                    navigationManager.push(.editPost)
                    isPresented = false
                } label: {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("편집")
                    }
                    .foregroundStyle(.black)
                }
                
                Button {
                    isPresentedDeleteAlert = true // 삭제 확인용 알럿
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("삭제")
                    }
                    .foregroundStyle(.red)
                }
                .alert("게시물을 삭제하시겠습니까", isPresented: $isPresentedDeleteAlert) {
                    Button("취소", role: .cancel) {
                        isPresentedDeleteAlert = false
                    }
                    Button("삭제하기", role: .destructive) {
                        isPresentedDeleteAlert = false
                        Task {
                            try await communityStore.deletePost(postId: communityStore.selectedPost.id)
                        }
                        isPresented = false
                    }
                }
            }
            .listStyle(.automatic)
            .listRowBackground(Color(uiColor: .systemGray4))
            .padding(.top, 25)
            .background(Color(uiColor: .systemGray6))
        } else {
            List {
                Button { // 대화걸기
                    navigationManager.selection = 2 // 채팅탭으로 이동
                    navigationManager.popToRoot()
                    chatStore.enteredChatRoom = nil
                    chatStore.enteredChatLogs = []
                    
                    Task {
                        let user = try await userStore.getUserInfo(id: communityStore.selectedPost.author.id) // 게시글 작성자 정보 찾기
                        if try await chatStore.findChatRoom(user1: userStore.user.id, user2: user.id) { // 이미 채팅방이 있는 경우
                            if let enteredChatRoom = chatStore.enteredChatRoom {
                                navigationManager.push(.chatRoom(enteredChatRoom, user))
                            }
                        } else {
                            if let enteredChatRoom = chatStore.enteredChatRoom {
                                // 채팅방 나가기 한 경우
                                try await chatStore.updateChatRoom(enteredChatRoom)
                                navigationManager.push(.chatRoom(enteredChatRoom, user))
                            } else {
                                try await chatStore.saveChatRoom(user.id) // 방 생성 후 채팅방 찾아서 이동
                                if let enteredChatRoom = chatStore.enteredChatRoom {
                                    navigationManager.push(.chatRoom(enteredChatRoom, user))
                                }
                            }
                        }
                        isPresented = false
                    }
                } label: {
                    HStack {
                        Image(systemName: "message")
                        Text("대화걸기")
                    }
                    .foregroundStyle(.black)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.bubble")
                        Text("신고")
                    }
                    .foregroundStyle(.red)
                }
            }
            .listStyle(.automatic)
            .listRowBackground(Color(uiColor: .systemGray4))
            .padding(.top, 25)
            .background(Color(uiColor: .systemGray6))
        }
    }
}
