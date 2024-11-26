//
//  ChatView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(ChatStore.self) private var chatStore: ChatStore
    let userStore = UserStore.shared
    
    @State private var components: [(chatRoom: ChatRoom, chatLogs: [ChatLog], otherUser: User)] = []
    @State private var selected: Int = -1
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if components.count == 0 {
                    Spacer()
                    Text("게시물을 공유하고 동행인을 찾아보세요")
                        .foregroundStyle(.gray)
                    Spacer()
                } else {
                    List(components, id: \.chatRoom) { component in
                        HStack {
                            if isEditing {
                                Button {
                                    selected = selected == component.chatRoom.id ? -1 : component.chatRoom.id
                                } label: {
                                    Image(systemName: selected == component.chatRoom.id ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundStyle(selected == component.chatRoom.id ? Color("accentColor") : Color(uiColor: .systemGray4))
                                }
                            }
                            
                            Button {
                                chatStore.enteredChatRoom = component.chatRoom
                                chatStore.enteredChatLogs = component.chatLogs
                                
                                DispatchQueue.main.async {
                                    navigationManager.push(.chatRoom(component.chatRoom, component.otherUser))
                                }
                            } label: {
                                HStack {
                                    if let image = UserStore.convertStringToImage(component.otherUser.profileImage) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(5)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(5)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .foregroundStyle(Color("accentColor").opacity(0.2))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(component.otherUser.nickname)
                                        
                                        if let log = component.chatLogs.last {
                                            Text(log.message == "" ? "(여행루트)" : log.message)
                                                .lineLimit(1)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                    .padding(.leading, 5)
                                    
                                    if let log = component.chatLogs.last {
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 10) {
                                            Text("\(chatStore.timeDifference(log.createdAt))")
                                                .font(.footnote)
                                                .foregroundStyle(.gray)
                                            
                                            Circle()
                                                .frame(width: 15, height: 15)
                                                .overlay {
                                                    // TODO: 안읽은 메세지 카운트
                                                    Text(log.writeUser != userStore.user.id ? "" : "")
                                                        .font(.footnote)
                                                        .foregroundStyle(.white)
                                                }
                                                .foregroundStyle(log.writeUser != userStore.user.id ? /*.orange*/.clear : .clear)
                                        }
                                        .padding(.leading, 5)
                                    }
                                }
                            }
                            .disabled(isEditing)
                        }
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button {
                                Task {
                                    try await chatStore.leaveChatRoom(component.chatRoom)
                                }
                            } label: {
                                Image(systemName: "door.left.hand.open")
                            }
                            .tint(.red)
                        }
                    }
                    .environment(\.editMode, Binding.constant(self.isEditing ? EditMode.active : EditMode.inactive))
                    .listStyle(.plain)
                }
            }
        }
        .onDisappear {
            selected = -1
        }
        .navigationTitle("채팅")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    Button {
                        Task {
                            try await chatStore.saveChatLog(selected, message: "", route: chatStore.forShareRoute, image: nil)
                            chatStore.isEditing.toggle()
                            chatStore.forShareRoute = nil
                        }
                    } label: {
                        Text("완료")
                            .foregroundStyle(Color("accentColor"))
                    }
                }
            }
        }
        .onAppear {
            isEditing = chatStore.isEditing
        }
        .onChange(of: chatStore.isNeedUpdate) { oldValue, newValue in
            // 로그가 하나도 없는 경우엔 채팅 목록에서 안보이도록 함, 나가기 한 방은 걸러줌
            components = chatStore.forChatComponents.filter {
                $0.chatLogs.count > 0 && (($0.chatRoom.user1 == userStore.user.id && $0.chatRoom.isVisible == 1) || ($0.chatRoom.user2 == userStore.user.id && $0.chatRoom.isVisible == 2) || $0.chatRoom.isVisible == 0)
            }
        }
        .onChange(of: chatStore.isEditing) { oldValue, newValue in
            isEditing = chatStore.isEditing
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
