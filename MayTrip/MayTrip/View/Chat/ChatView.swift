//
//  ChatView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ChatView: View {
    @Environment(ChatStore.self) private var chatStore: ChatStore
    let userStore = UserStore.shared
    
    @State private var components: [(chatRoom: ChatRoom, chatLogs: [ChatLog], otherUser: User)] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                if components.count == 0 {
                    Spacer()
                    Text("게시물을 공유하고 동행인을 찾아보세요")
                    Spacer()
                } else {
                    List {
                        ForEach(0..<components.count, id: \.self) { index in
                            HStack {
                                if let image = components[index].otherUser.profileImage, image != "" {
                                    // TODO: 이미지 띄우기
                                    Image(systemName: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(.gray)
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(components[index].otherUser.nickname)")
                                    
                                    Text(components[index].chatLogs.last == nil ? "" : "\(components[index].chatLogs.last!.message)")
                                        .lineLimit(1)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.leading, 5)
                                
                                if let log = components[index].chatLogs.last {
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
                            .background {
                                NavigationLink(destination: ChattingRoomView(chatRoom: components[index].chatRoom, chatLogs: components[index].chatLogs, otherUser: components[index].otherUser)) {
                                }
                                .opacity(0)
                            }
                            .swipeActions {
                                Button {
                                    Task {
                                        try await chatStore.leaveChatRoom(components[index].chatRoom)
                                    }
                                } label: {
                                    Image(systemName: "door.left.hand.open")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: chatStore.isNeedUpdate) { oldValue, newValue in
                components = chatStore.forChatComponents
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
