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
    @State var message: String = ""
    @FocusState var focused: Bool
    var chatStore = DummyChatStore.shared
    var routeStore = DummyRouteStore.shared
    let chatRoom: DummyChatRoom
    var chatLogs: [DummyChatLog] {
        chatStore.getChatLogs(chatRoom.id)
    }
    @State var isScrollTop: Bool = true
    @State var isSend: Bool = false
    
    // TODO: 루트 공유
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:  15)
                }
                Spacer()
                
                // 채팅 상대 이름
                Text("\(chatStore.getOtherUser(chatRoom).nickname)")
                
                Spacer()
            }
            .foregroundStyle(.black)
            .font(.title3)
            .padding(.horizontal)
            
            Divider()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    VStack(alignment: .center) {
                        //                            Text("2024년 11월 04일")
                        //                                .font(.footnote)
                        //                                .foregroundStyle(.gray)
                        //                                .padding()
                        
                        ForEach(chatLogs) { log in
                            // TODO: 상대가 보낸 메세지인지 분기 로직 추가
                            if log.write_user == signedUser.id {
                                // 내가 보낸 메세지
                                HStack(alignment: .bottom, spacing: 0) {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        //                                            Text("읽음")
                                        Text("\(chatStore.convertDateToTimeString(log.created_at))")
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    
                                    Text("\(log.message)")
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(.tint)
                                                .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                                        }
                                        .padding(.horizontal)
                                }
                                .padding(.bottom)
                            } else {
                                // 상대가 보낸 메세지
                                HStack(alignment: .bottom, spacing: 0) {
                                    Text("\(log.message)")
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
                                        Text("\(chatStore.convertDateToTimeString(log.created_at))")
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
            }
            .padding(.bottom, 15)
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            
            Spacer()
            
            Divider()
            
            HStack {
                TextField("메세지를 입력하세요", text: $message)
                    .onChange(of: message) { oldValue, newValue in
                        
                    }
                    .keyboardType(.default)
                    .focused($focused)
                    .onSubmit {
                        chatStore.saveChatLog(chatRoom.id, message: message)
                        message = ""
                        focused = false
                        isSend = true
                    }
                
                Button {
                    chatStore.saveChatLog(chatRoom.id, message: message)
                    message = ""
                    focused = false
                    isSend = true
                } label: {
                    VStack {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.tint)
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
        .navigationBarBackButtonHidden()
        .onTapGesture {
            focused = false
        }
    }
}

struct RecruitmentNoticeView: View {
    var routeStore = DummyRouteStore.shared
    let route: DummyTripRoute?
    
    var body: some View {
        if let route {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
                .overlay {
                    // storke 쓰면 배경색이 안먹혀서 사각형 한번 더 그려줌
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                        .overlay {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(route.title)")
                                        .lineLimit(1)
                                        .bold()
                                    
                                    HStack(spacing: 10) {
                                        // 여행지
                                        ForEach(0..<3) { index in
                                            if index < route.cities.count {
                                                Text("\(index == 0 ? route.cities[index] : "·  \(route.cities[index])")")
                                                    .lineLimit(1)
                                            }
                                        }
                                        // 여행 날짜, 기간
                                        Text("\(routeStore.convertPeriodToString(route.start_date, end: route.end_date))여행")
                                    }
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                            }
                            // 현재 여행 중인 카드만 진한 컬러로
                            .foregroundStyle(.black)
                            //                            .foregroundStyle(.white)
                            .padding()
                            .padding(.vertical)
                        }
                }
            
                .padding([.horizontal, .top])
                .background {
                    Rectangle()
                        .foregroundColor(.white)
                }
                .padding(.bottom)
                .frame(width: .infinity, height: 130)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    ChattingRoomView(chatRoom: DummyChatStore.shared.chatRooms[0])
}
