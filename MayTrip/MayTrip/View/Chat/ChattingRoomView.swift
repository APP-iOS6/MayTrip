//
//  ChattingRoomView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI
import UIKit

struct ChattingRoomView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ChatStore.self) private var chatStore: ChatStore
    @EnvironmentObject var navigationManager: NavigationManager
    let userStore = UserStore.shared
    @State var message: String = ""
    @State var route: Int?
    @State var image: String?
    @FocusState var focused: Bool
    let chatRoom: ChatRoom
    var chatLogs: [ChatLog]
    let otherUser: User
    @State var isScrollTop: Bool = true
    @State var isSend: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // 채팅을 하나도 안보내고 나가는 경우엔 채팅방 삭제
                    if chatLogs.count == 0 {
                        Task {
                            try await chatStore.deleteChatRoom(chatRoom)
                        }
                    }
                    if navigationManager.chatPath.isEmpty {
                        dismiss()
                    } else {
                        navigationManager.pop()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:  15)
                }
                Spacer()
                
                // 채팅 상대 이름
                Text(otherUser.nickname)
                    .bold()
                
                Spacer()
            }
            .foregroundStyle(.black)
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .center) {
                    // TODO: 날짜별로 표시해주는 디바이더 추가
                    //                            Text("2024년 11월 04일")
                    //                                .font(.footnote)
                    //                                .foregroundStyle(.gray)
                    //                                .padding()
                    
                    ForEach(chatLogs) { log in
                        if log.writeUser == userStore.user.id {
                            // 내가 보낸 메세지
                            HStack(alignment: .bottom, spacing: 0) {
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    //                                            Text("읽음")
                                    Text("\(chatStore.convertDateToTimeString(log.createdAt))")
                                }
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                
                                Text("\(log.message)")
                                    .font(.callout)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background {
                                        Rectangle()
                                            .foregroundStyle(Color("accentColor"))
                                            .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                                    }
                                    .padding(.horizontal)
                            }
                            .padding(.bottom)
                        } else {
                            // 상대가 보낸 메세지
                            HStack(alignment: .bottom, spacing: 0) {
                                Text("\(log.message)")
                                    .font(.callout)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background {
                                        Rectangle()
                                            .foregroundStyle(Color(uiColor: .systemGray6))
                                            .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
                                    }
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading) {
                                    //                                            Text("읽음")
                                    Text("\(chatStore.convertDateToTimeString(log.createdAt))")
                                }
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
            .refreshable {
                Task {
                    try await chatStore.setAllComponents(true)
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            
            VStack {
                Divider()
                
                HStack {
                    TextField("메세지를 입력하세요", text: $message)
                        .onChange(of: message) { oldValue, newValue in
                            
                        }
                        .keyboardType(.default)
                        .focused($focused)
                        .onSubmit {
                            Task {
                                guard message != "" else { return }
                                
                                try await chatStore.saveChatLog(chatRoom.id, message: message, route: route, image: image)
                                
                                message = ""
                                focused = true
                                isSend = true
                            }
                        }
                    
                    Button {
                        Task {
                            guard message != "" else { return }
                            
                            try await chatStore.saveChatLog(chatRoom.id, message: message, route: route, image: image)
                            
                            message = ""
                            focused = false
                            isSend = true
                        }
                    } label: {
                        VStack {
                            Image(systemName: "paperplane")
                                .foregroundStyle(Color("accentColor"))
                        }
                        .foregroundStyle(Color(uiColor: .gray))
                    }
                    .disabled(message.count == 0)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 1)
                )
                .padding()
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            focused = false
        }
        .onDisappear {
            if chatLogs.count == 0 {
                Task {
                    try await chatStore.deleteChatRoom(chatRoom)
                }
            }
        }
    }
}

