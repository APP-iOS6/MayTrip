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
    @EnvironmentObject var tripRouteStore: TripRouteStore
    
    @FocusState var focused: Bool
    @State var message: String = ""
    @State var image: String?
    @State var isScrollTop: Bool = true
    @State var isSend: Bool = false
    @State var isShowRouteList: Bool = false
    @State var selectedRouted: Int? = nil
    private let dateStore: DateStore = .shared
    let userStore = UserStore.shared
    
    let chatRoom: ChatRoom
    let otherUser: User
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    // TODO: 날짜별로 표시해주는 디바이더 추가
                    //                            Text("2024년 11월 04일")
                    //                                .font(.footnote)
                    //                                .foregroundStyle(.gray)
                    //                                .padding()
                    
                    ForEach(chatStore.enteredChatLogs) { log in
                        if log.writeUser == userStore.user.id { // 내가 보낸 메세지
                            if let route = tripRouteStore.getSharedTripRoute(log.route) {
                                HStack(alignment: .bottom, spacing: 0) {
                                    Spacer()
                                    Button {
                                        // 디테일 뷰 이동
                                        Task {
                                            try await tripRouteStore.getTripRoute(id: route.id)
                                            DispatchQueue.main.async {
                                                navigationManager.push(.routeDetail(tripRouteStore.tripRoute.first ?? SampleTripRoute.sampleRoute))
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                    Text(route.city[0])
                                                        .font(.footnote)
                                                        .foregroundStyle(Color("accentColor"))
                                                        .padding(.horizontal, 13)
                                                        .padding(.vertical, 5)
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                                                .foregroundStyle(Color("accentColor").opacity(0.3))
                                                        }
                                                }
                                                Text(route.title)
                                                    .font(.title3)
                                                    .lineLimit(2)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .bold()
                                                    .foregroundStyle(.black)
                                                    .padding(.top, 8)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text("\(dateStore.convertPeriodToString(route.start_date, end: route.end_date)) 일정")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                                    .padding(.top, 5)
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 15)
                                        .padding(.trailing, 5)
                                        .frame(width: UIScreen.main.bounds.width / 3 * 2)
                                    }
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color("accentColor").opacity(0.3), lineWidth: 1)
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.bottom)
                            }
                            
                            if log.message.count > 0 {
                                HStack(alignment: .bottom, spacing: 0) {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        //                                            Text("읽음")
                                        Text(chatStore.convertDateToTimeString(log.createdAt))
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    
                                    Text(log.message)
                                        .font(.callout)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 18)
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(Color("accentColor"))
                                                .cornerRadius(20, corners: [.topLeft, .bottomLeft, .bottomRight])
                                        }
                                        .padding(.horizontal)
                                }
                                .padding(.bottom)
                            }
                        } else { // 상대가 보낸 메세지
                            if let route = tripRouteStore.getSharedTripRoute(log.route) {
                                HStack(alignment: .bottom, spacing: 0) {
                                    Button {
                                        // 디테일 뷰 이동
                                        Task {
                                            try await tripRouteStore.getTripRoute(id: route.id)
                                            DispatchQueue.main.async {
                                                navigationManager.push(.routeDetail(tripRouteStore.tripRoute.first ?? SampleTripRoute.sampleRoute))
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                    Text(route.city[0])
                                                        .font(.footnote)
                                                        .foregroundStyle(Color("accentColor"))
                                                        .padding(.horizontal, 13)
                                                        .padding(.vertical, 5)
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                                                .foregroundStyle(Color("accentColor").opacity(0.2))
                                                        }
                                                }
                                                Text(route.title)
                                                    .font(.title3)
                                                    .lineLimit(2)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .bold()
                                                    .foregroundStyle(.black)
                                                    .padding(.top, 8)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text("\(dateStore.convertPeriodToString(route.start_date, end: route.end_date)) 일정")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                                    .padding(.top, 5)
                                            }
                                            Spacer()
                                        }
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 15)
                                        .padding(.trailing, 5)
                                        .frame(width: UIScreen.main.bounds.width / 3 * 2)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
                                        }
                                        .padding(.horizontal)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom)
                            }
                            
                            if log.message.count > 0 {
                                HStack(alignment: .bottom, spacing: 0) {
                                    Text(log.message)
                                        .font(.callout)
                                        .foregroundStyle(.black)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 18)
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(Color(uiColor: .systemGray6))
                                                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                                        }
                                        .padding(.horizontal)
                                    
                                    VStack(alignment: .leading) {
                                        //                                            Text("읽음")
                                        Text(chatStore.convertDateToTimeString(log.createdAt))
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
            .refreshable {
                Task {
                    try await chatStore.setAllComponents(true)
                }
            }
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                HStack(spacing: 5) {
                    if tripRouteStore.myTripRoutes.count > 0 {
                        Button {
                            isShowRouteList.toggle()
                        } label: {
                            Image(systemName: isShowRouteList ? "xmark" : "line.horizontal.3")
                                .frame(width: 10, height: 10)
                                .foregroundStyle(Color("accentColor"))
                                .padding(15)
                                .background {
                                    Circle()
                                        .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
                                }
                        }
                    }
                    
                    HStack {
                        TextField("메세지를 입력하세요", text: $message)
                            .keyboardType(.default)
                            .focused($focused)
                            .onSubmit {
                                Task {
                                    guard message != "" || selectedRouted != nil else { return }
                                    
                                    try await chatStore.saveChatLog(chatRoom.id, message: message, route: selectedRouted, image: image)
                                    
                                    message = ""
                                    selectedRouted = nil
                                    isSend = true
                                    isShowRouteList = false
                                }
                            }
                        
                        Button {
                            Task {
                                guard message != "" || selectedRouted != nil else { return }
                                
                                try await chatStore.saveChatLog(chatRoom.id, message: message, route: selectedRouted, image: image)
                                
                                message = ""
                            }
                        } label: {
                            VStack {
                                Image(systemName: "paperplane")
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(message.count == 0 && selectedRouted == nil ? Color(uiColor: .gray) : Color("accentColor"))
                            }
                        }
                        .disabled(message.count == 0 && selectedRouted == nil)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 1)
                    )
                }
                .padding()
                
                if isShowRouteList, tripRouteStore.myTripRoutes.count > 0 {
                    RouteListForChatView(selectedRouted: $selectedRouted, routes: tripRouteStore.myTripRoutes)
                }
            }
            .background(.white)
        }
        .onChange(of: isShowRouteList, { oldValue, newValue in
            selectedRouted = nil
        })
        .padding(.bottom, 1)
        .navigationBarBackButtonHidden()
        .navigationTitle(otherUser.nickname)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    // 채팅을 하나도 안보내고 나가는 경우엔 채팅방 삭제
                    if chatStore.enteredChatLogs.count == 0 {
                        Task {
                            try await chatStore.deleteChatRoom(chatRoom)
                        }
                    }
                    
                    // entered 변수 리셋
                    chatStore.enteredChatRoom = nil
                    chatStore.enteredChatLogs = []
                    
                    if navigationManager.chatPath.isEmpty {
                        dismiss()
                    } else {
                        navigationManager.pop()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                .foregroundStyle(.black)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            focused = false
        }
    }
}

