//
//  CommunityMenuSheetView.swift
//  MayTrip
//
//  Created by 강승우 on 11/13/24.
//

import SwiftUI

struct CommunityMenuSheetView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(ChatStore.self) private var chatStore: ChatStore
    @Binding var isPresented: Bool
    @Binding var selectedPostOwner: Int
    @Binding var selectedPostId: Int
    
    let userStore = UserStore.shared
    
    var body: some View {
        if userStore.user.id == selectedPostOwner { // 제작자의 경우
            List {
                Button {
                    // 게시글 편집
                } label: {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("편집")
                    }
                    .foregroundStyle(.black)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("삭제")
                    }
                    .foregroundStyle(.red)
                }
            }
            .listStyle(.automatic)
            .listRowBackground(Color(uiColor: .systemGray4))
            .padding(.top, 25)
            .background(Color(uiColor: .systemGray6))
        } else {
            List {
                Button { // 대화걸기
                    Task {
                        try await chatStore.saveChatRoom(selectedPostOwner)
                        let user = try await userStore.getUserInfo(id: selectedPostOwner)
                        let chatComponent = chatStore.forChatComponents.filter {
                            $0.otherUser == user
                        }
                        if let chatComponent = chatComponent.first {
                            navigationManager.push(.chatRoom(chatComponent.chatRoom, [], user))
                        }
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
