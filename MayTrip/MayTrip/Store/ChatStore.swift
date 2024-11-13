//
//  ChatStore.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI
import Observation
import Realtime

@Observable
class ChatStore {
    private let db = DBConnection.shared
    private let userStore = UserStore.shared
    
    private var chatRooms: [ChatRoom] = []
 
    private(set) var forChatComponents: [(chatRoom: ChatRoom, chatLogs: [ChatLog], otherUser: User)] = []

    init() {
        Task {
            try await setAllComponents()
            
            let channel =  db.realtimeV2.channel("observe")
            let changes = channel.postgresChange(AnyAction.self, schema: "public")

            await channel.subscribe()
            
            for await _ in changes {
                try await setAllComponents()
            }
        }
    }
    
    // 채팅에 필요한 컴포넌트들 세팅
    @MainActor
    func setAllComponents(_ isRefresh: Bool = false) async throws {
        Task {
            try await fetchChatRooms()
            
            for chatRoom in chatRooms {
                let chatLogs = try await fetchChatLogs(chatRoom, isRefresh: isRefresh)
                let otherUser = try await getOtherUser(chatRoom)
                let forChatComponent: (ChatRoom, [ChatLog], User) = (chatRoom, chatLogs, otherUser)

                // 화면 관련 부분은 메인에서 작업
//                DispatchQueue.main.asyncAndWait {
                    forChatComponents.removeAll(where: { $0.chatRoom.id == chatRoom.id })
                    forChatComponents.append(forChatComponent)
//                }
            }
        }
    }
    
    // 유저가 포함된 대화방만 불러옴
    private func fetchChatRooms() async throws {
        do {
            chatRooms = try await db
                .from("CHAT_ROOM")
                .select()
                .or("user1.eq.\(userStore.user.id), user2.eq.\(userStore.user.id)")
                .order("created_at", ascending: false) // 내림차순으로 정렬
                .execute()
                .value
        } catch {
            print("Fail to fetch chat rooms: \(error)")
        }
    }
    
    // 대화방 대화내용 불러오기
    private func fetchChatLogs(_ chatRoom: ChatRoom, isRefresh: Bool = false) async throws -> [ChatLog] {
        do {
            let component = forChatComponents.filter {
                $0.chatRoom.id == chatRoom.id
            }.first
            
            var preLogs: [ChatLog] = []
            
            if isRefresh {
                preLogs = component != nil ? component!.chatLogs : preLogs
            }
            
            var newLogs: [ChatLog] = try await db
                .from("CHAT_LOG")
                .select()
                .eq("chat_room", value: chatRoom.id)
                .order("created_at", ascending: false) // 내림차순으로 정렬
                .limit(30)
                .range(from: preLogs.count, to: preLogs.count + 30)
                .execute()
                .value
            
            newLogs = preLogs.count != 0 ? preLogs + newLogs : newLogs
            newLogs.sort(by: { $0.createdAt < $1.createdAt })
            
            return newLogs
        } catch {
            print("Fail to fetch chat rooms: \(error)")
            throw error
        }
    }
    
    // 채팅룸 저장
    func saveChatRoom(_ user: Int) async throws {
        do {
            let chatRoom: ChatRoomPost = ChatRoomPost(user1: userStore.user.id, user2: user)
            try await db.from("CHAT_ROOM").insert(chatRoom)
                .execute()
        } catch {
            print("Fail to save chat room: \(error)")
        }
    }
    
    // 대화내용 저장
    func saveChatLog(_ chatRoom: Int, message: String, route: Int?, image: String?) async throws {
        do {
            let chatLog: ChatLogPost = ChatLogPost(writeUser: userStore.user.id, chatRoom: chatRoom, message: message, route: route, image: image)
            try await db.from("CHAT_LOG").insert(chatLog)
                .execute()
        } catch {
            print("Fail to save chat log: \(error)")
        }
    }
    
    // 채팅방 삭제
    func deleteChatRoom(_ chatRoom: Int) async throws {
        do {
            try await db.from("CHAT_ROOM").delete().eq("id", value: chatRoom).execute()
        } catch {
            print("Fail to delete chat room: \(error)")
        }
    }
    
    // 채팅 상대 유저를 반환
    private func getOtherUser(_ chatRoom: ChatRoom) async throws -> User {
        do {
            let userId = chatRoom.user1 == userStore.user.id ? chatRoom.user2 : chatRoom.user1
            
            let result: [User] = try await db
                .from("USER")
                .select()
                .eq("id", value:userId)
                .execute()
                .value
            
            return result[0]
        } catch {
            print("Fail to delete chat room: \(error)")
            throw error
        }
    }
    
    // 날짜를 입력 받아서 현재 시간으로부터 얼마나 차이가 나는지 계산
    func timeDifference(_ date: Date) -> String {
        let current = Calendar.current
        
        let dateDiff = current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        let dateString = formatter.string(from: date)
        
        if case let (year?, month?, day?, hour?, minute?) = (dateDiff.year, dateDiff.month, dateDiff.day, dateDiff.hour, dateDiff.minute) {
            
            if year == 0 || month == 0 || day == 0 {
                if hour != 0 {
                    return "\(hour)시간 전"
                }
                if minute != 0 {
                    return "\(minute)분 전"
                }
                return "방금 전"
            }
        }
        return dateString
    }
    
    // 전송된 날짜를 입력받아서 시간 스트링으로 반환
    func convertDateToTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: date)
    }
}
