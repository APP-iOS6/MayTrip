//
//  ChatView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ChatView: View {
    var chatStore = DummyChatStore.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(chatStore.chatRooms) { chatRoom in
                    HStack {
                        // 유저 프로필 이미지
                        Image(systemName: chatStore.getOtherUser(chatRoom).profile_image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        if let log = chatStore.getChatLogs(chatRoom.id).last {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(chatStore.getOtherUser(chatRoom).nickname)")
                                
                                Text("\(log.message)")
                                    .lineLimit(1)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.leading, 5)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 10) {
                                
                                Text("\(chatStore.timeDifference(log.created_at))")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                
                                
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .overlay {
                                        // TODO: 안읽은 메세지 카운트
                                        Text(log.write_user != signedUser.id ? "" : "")
                                            .font(.footnote)
                                            .foregroundStyle(.white)
                                    }
                                    .foregroundStyle(log.write_user != signedUser.id ? /*.orange*/.clear : .clear)
                                
                            }
                            .padding(.leading, 5)
                        }
                    }
                    .background {
                        NavigationLink(destination: ChattingRoomView(chatRoom: chatRoom)) {
                            
                        }
                        .opacity(0)
                    }
                    .swipeActions {
                        Button {
                            chatStore.leaveChatRoom(chatRoom)
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

import Observation

struct DummyChatRoom: Identifiable {
    var id: Int
    var user1: Int
    var user2: Int
    var created_at: Date
    var updated_at: Date?
}

struct DummyChatLog: Identifiable {
    var id: Int = UUID().hashValue
    var write_user: Int
    var chat_room: Int
    var route: Int?
    var message: String
    var image: String?
    var created_at: Date
}

@Observable
class DummyChatStore {
    static let shared: DummyChatStore = DummyChatStore()
    
    private var allChatRooms: [DummyChatRoom] = [
        DummyChatRoom(id: 0, user1: signedUser.id, user2: users[1].id, created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init()),
        DummyChatRoom(id: 1, user1: signedUser.id, user2: users[2].id, created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5, hour: 6, minute: 30)) ?? .init()),
        DummyChatRoom(id: 2, user1: signedUser.id, user2: users[3].id, created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 4, minute: 30)) ?? .init()),
        DummyChatRoom(id: 3, user1: users[3].id, user2: users[2].id, created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5, hour: 6, minute: 30)) ?? .init()),
        DummyChatRoom(id: 4, user1: users[1].id, user2: users[3].id, created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 4, minute: 30)) ?? .init())]
    
    private var allChatLogs: [DummyChatLog] = [DummyChatLog(write_user: 0, chat_room: 1, message: "안녕하세요. 같이 여행가요. 이 루트로 여행 가는거 어떄요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init()), DummyChatLog(write_user: 1, chat_room: 1, message: "안녕하세요. 같이 여행가는거 너무 좋아요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 7, minute: 31)) ?? .init()), DummyChatLog(write_user: 0, chat_room: 1, message: "추가하고 싶은 여행지가 있나요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 00)) ?? .init()), DummyChatLog(write_user: 1, chat_room: 1, message: "지금 루트도 너무 좋아요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 1)) ?? .init()), DummyChatLog(write_user: 0, chat_room: 1, message: "오 다행이네요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init()), DummyChatLog(write_user: 0, chat_room: 1, message: "바이바이", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 2)) ?? .init())
    ,DummyChatLog(write_user: 0, chat_room: 0, message: "안녕하세요. 같이 여행가요. 이 루트로 여행 가는거 어떄요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init()), DummyChatLog(write_user: 1, chat_room: 0, message: "안녕하세요. 같이 여행가는거 너무 좋아요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 7, minute: 31)) ?? .init()), DummyChatLog(write_user: 0, chat_room: 0, message: "추가하고 싶은 여행지가 있나요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 20)) ?? .init()), DummyChatLog(write_user: 1, chat_room: 0, message: "지금 루트도 너무 좋아요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 1)) ?? .init()), DummyChatLog(write_user: 0, chat_room: 0, message: "오 다행이네요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init())
   ,DummyChatLog(write_user: 1, chat_room: 2, message: "안녕하세요. 같이 여행가요. 이 루트로 여행 가는거 어떄요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 6, minute: 30)) ?? .init()), DummyChatLog(write_user: 2, chat_room: 2, message: "안녕하세요. 같이 여행가는거 너무 좋아요", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 7, minute: 31)) ?? .init()), DummyChatLog(write_user: 1, chat_room: 2, message: "추가하고 싶은 여행지가 있나요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 40)) ?? .init()),
   DummyChatLog(write_user: 1, chat_room: 3, message: "같이 여행가는거 어때요?", created_at: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 5, hour: 8, minute: 00)) ?? .init())
    ]
    
    var chatRooms: [DummyChatRoom] {
        allChatRooms.filter {
            $0.user1 == signedUser.id || $0.user2 == signedUser.id
        }
    }
    
    func getChatLogs(_ chatRoom: Int) -> [DummyChatLog] {
        allChatLogs.filter {
            $0.chat_room == chatRoom
        }.sorted(by: {$0.created_at < $1.created_at})
    }
    
    func saveChatLog(_ chatRoom: Int, message: String) {
        let chatLog = DummyChatLog(write_user: signedUser.id, chat_room: chatRoom, message: message, created_at: Date())
        allChatLogs.append(chatLog)
    }
    
    func leaveChatRoom(_ chatRoom: DummyChatRoom) {
        allChatRooms.removeAll { $0.id == chatRoom.id }
    }
    
    // 날짜를 입력 받아서 현재 시간으로부터 얼마나 차이가 나는지 계산
    func timeDifference(_ date: Date) -> String {
        let current = Calendar.current
        
        let dateDiff = current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        let dateString = formatter.string(from: date)
        
        if case let (year?, month?, day?, hour?, minute?, second?) = (dateDiff.year, dateDiff.month, dateDiff.day, dateDiff.hour, dateDiff.minute, dateDiff.second) {
            
            if year == 0 || month == 0 || day == 0 {
                return hour > minute ? "\(hour)시간 전" : (minute > second ? "\(minute)분 전" : "방금 전")
            }
        }
        return dateString
    }
    
    func getOtherUser(_ chatRoom: DummyChatRoom) -> DummyUser {
        return users.filter {
            $0.id == (chatRoom.user1 == signedUser.id ? chatRoom.user2 : chatRoom.user1)
        }.first ?? signedUser
    }
    
    func convertDateToTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a HH:mm"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: date)
    }
}


#Preview {
    NavigationStack {
        ChatView()
    }
}
