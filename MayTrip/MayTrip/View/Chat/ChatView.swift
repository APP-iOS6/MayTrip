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
    
    var body: some View {
        NavigationStack {
            if chatStore.forChatComponents.count == 0 {
                Text("게시물을 공유하고 동행인을 찾아보세요")
            } else {
                List {
                    ForEach(0..<chatStore.forChatComponents.count, id: \.self) { index in
                        HStack {
                            if let image = chatStore.forChatComponents[index].otherUser.profileImage, image != "" {
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
                            
                            if let log = chatStore.forChatComponents[index].chatLogs.last {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(chatStore.forChatComponents[index].otherUser.nickname)")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(log.message)")
                                        .font(.callout)
                                        .lineLimit(1)
                                }
                                .padding(.leading, 5)
                                
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
                            NavigationLink(destination: ChattingRoomView(chatRoom: chatStore.forChatComponents[index].chatRoom, chatLogs: chatStore.forChatComponents[index].chatLogs, otherUser: chatStore.forChatComponents[index].otherUser)) {
                                
                            }
                            .opacity(0)
                        }
                        .swipeActions {
                            Button {
                                Task {
                                    try await chatStore.deleteChatRoom(chatStore.forChatComponents[index].chatRoom.id)
                                }
                            } label: {
                                Image(systemName: "door.left.hand.open")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("채팅")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
