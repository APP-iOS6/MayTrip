//
//  ChatStore.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI
import Observation
import Realtime
import Supabase

@Observable
class ChatStore {
    private let db = DBConnection.shared
    private let userStore = UserStore.shared
    private var chatRooms: [ChatRoom] = []
    private(set) var forChatComponents: [(chatRoom: ChatRoom, chatLogs: [ChatLog], otherUser: User)] = []
    private(set) var isNeedUpdate: Bool = false
    
    var enteredChatRoom: ChatRoom? = nil
    var enteredChatLogs: [ChatLog] = []
    var forShareRoute: Int? = nil
    var isEditing: Bool = false
    
    @MainActor
    init() {
        Task {
            try await setAllComponents()
            
            let channel =  db.realtimeV2.channel("observe")
            let changes = channel.postgresChange(AnyAction.self, schema: "public")
            
            await channel.subscribe()
            
            for await change in changes {
                if let data = change.rawMessage.payload["data"]?.queryValue.data(using: .utf8) {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let type: String? = dictionary?["type"] as? String
                        let table: String? = dictionary?["table"] as? String
                        let record: Dictionary? = dictionary?["record"] as? Dictionary<String, Any>
                        let id: Int? = record?["id"] as? Int
                        
                        switch type {
                        case "INSERT":
                            if table == "CHAT_ROOM" {
                                if let chatRoom = try await fetchChatRooms(id) {
                                    let chatLogs = try await fetchChatLogs(chatRoom: chatRoom)
                                    let otherUser = try await getOtherUser(chatRoom)
                                    let forChatComponent: (ChatRoom, [ChatLog], User) = (chatRoom, chatLogs, otherUser)
                                    
                                    forChatComponents.removeAll(where: { $0.chatRoom.id == chatRoom.id })
                                    forChatComponents.insert(forChatComponent, at: 0) // 최신걸 제일 위에
                                    
                                    if let room = enteredChatRoom {
                                        if chatRoom.id == room.id {
                                            enteredChatLogs = chatLogs
                                        }
                                    }
                                    // 모든 작업이 끝나고 UI를 업데이트한다
                                    isNeedUpdate.toggle()
                                }
                            } else {
                                // 새로 생긴 채팅만 로그하고 나머지는 이미 fetch 되어 있는 정보를 사용한다.
                                let room: Int? = record?["chat_room"] as? Int
                                let component: (chatRoom: ChatRoom, chatLogs: [ChatLog], otherUser: User)? = forChatComponents.filter {
                                    $0.chatRoom.id == room
                                }.first
                                
                                if let component = component {
                                    let chatLogs = try await fetchChatLogs(id, chatRoom: component.chatRoom)
                                    let forChatComponent: (ChatRoom, [ChatLog], User) = (component.chatRoom, chatLogs, component.otherUser)
                                    
                                    forChatComponents.removeAll(where: { $0.chatRoom.id == component.chatRoom.id })
                                    forChatComponents.insert(forChatComponent, at: 0) // 최신걸 제일 위에
                                    
                                    if let room = enteredChatRoom {
                                        if component.chatRoom.id == room.id {
                                            enteredChatLogs = chatLogs
                                        }
                                    }
                                    // 모든 작업이 끝나고 UI를 업데이트한다
                                    isNeedUpdate.toggle()
                                }
                            }
                            print("INSERT")
                        case "UPSERT":
                            print("UPSERT")
                        case "UPDATE":
                            // 채팅로그는 업데이트 개념이 아니라서 업데이트 이벤트 발생하지 않지만 채팅로그가 쌓일때 채팅방이 업데이트 된다. 하지만 이미 채팅로그 insert에서 최신으로 fetch 하기 때문에 따로 로그를 가져오지 않는다(중복 fetch 방지)
                            if table == "CHAT_ROOM" {
                                // 로그나 상대 정보는 그대로 두고 채팅방의 업데이트 정보만 새로 fetch
                                if let chatRoom = try await fetchChatRooms(id) {
                                    let forChatComponent: (ChatRoom, [ChatLog], User)? = forChatComponents.filter {
                                        $0.chatRoom.id == id
                                    }.first
                                    
                                    var chatLogs: [ChatLog] = []
                                    
                                    if enteredChatRoom != nil, enteredChatRoom!.id == id {
                                        chatLogs = try await fetchChatLogs(chatRoom: chatRoom)
                                        enteredChatRoom = chatRoom // isVisible 업데이트 때문에 새로 넣어줌
                                        enteredChatLogs = chatLogs
                                    }
                                    
                                    if var forChatComponent = forChatComponent { // 상대유저는 변경되지 않기 때문에 그대로 넣어줌
                                        forChatComponent.0 = chatRoom
                                        forChatComponent.1 = chatLogs.count > 0 ? chatLogs : forChatComponent.1
                                        
                                        forChatComponents.removeAll(where: { $0.chatRoom.id == id })
                                        forChatComponents.insert(forChatComponent, at: 0) // 최신걸 제일 위에
                                        isNeedUpdate.toggle()
                                    }
                                }
                            }
                            print("UPDATE")
                        case "DELETE":
                            // 채팅방에서 모두 나간 경우엔 삭제, 삭제후 다시 패치 해준다
                            _ = try await fetchChatRooms()
                            
                            // 삭제된 채팅방 걸러냄
                            forChatComponents = forChatComponents.filter {
                                chatRooms.contains($0.chatRoom)
                            }
                            isNeedUpdate.toggle()
                            print("DELETE")
                        default:
                            print("not supported event")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // 채팅에 필요한 컴포넌트들 세팅
    func setAllComponents(_ isRefresh: Bool = false) async throws {
        Task {
            _ = try await fetchChatRooms()
            
            for chatRoom in chatRooms {
                let chatLogs = try await fetchChatLogs(chatRoom:chatRoom, isRefresh: isRefresh)
                let otherUser = try await getOtherUser(chatRoom)
                let forChatComponent: (ChatRoom, [ChatLog], User) = (chatRoom, chatLogs, otherUser)
                
                forChatComponents.removeAll(where: { $0.chatRoom.id == chatRoom.id })
                forChatComponents.insert(forChatComponent, at: 0)
            }
            isNeedUpdate.toggle()
        }
    }
    
    // 유저가 포함된 대화방만 불러옴
    private func fetchChatRooms(_ id: Int? = nil) async throws -> ChatRoom? {
        do {
            if let id = id {
                let newRoom: [ChatRoom] = try await db
                    .from("CHAT_ROOM")
                    .select()
                    .eq("id", value: id)
                    .or("user1.eq.\(userStore.user.id), user2.eq.\(userStore.user.id)")
                    .execute()
                    .value
                return newRoom.first
            } else {
                chatRooms = try await db
                    .from("CHAT_ROOM")
                    .select()
                    .or("user1.eq.\(userStore.user.id), user2.eq.\(userStore.user.id)")
                    .order("updated_at", ascending: true)
                    .execute()
                    .value
                
                // 나가기 한 채팅방 거르기
                chatRooms = chatRooms.filter {
                    if $0.isVisible == 0 {
                        return true
                    }
                    
                    if $0.user1 == userStore.user.id {
                        return $0.isVisible == 1 ? true : false
                    } else {
                        return $0.isVisible == 2 ? true : false
                    }
                }
                return nil
            }
        } catch {
            print("Fail to fetch chat rooms: \(error)")
            throw error
        }
    }
    
    // ID를 기반으로 이미 채팅방이 존재하는지 확인
    func findChatRoom(user1: Int, user2: Int) async throws -> Bool {
        let component = forChatComponents.filter {
            $0.otherUser.id == user2
        }.first
        
        // 제대로 채팅이 진행됐을때 둘다 채팅방에서 나간게 아니면(DELETE가 이루어지지 않은 경우, LEAVE 상황) 로컬 component가 존재해야함
        if let component = component {
            enteredChatRoom = component.chatRoom
            enteredChatLogs = component.chatLogs
            
            if (component.chatRoom.user1 == userStore.user.id && component.chatRoom.isVisible == 2) || (component.chatRoom.user2 == userStore.user.id && component.chatRoom.isVisible == 1) { // 채팅방에서 나갔다가 게시글 보고 다시 채팅 거는 경우를 위해서
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func updateChatRoom(_ chatRoom: ChatRoom) async throws {
        do {
            try await db.from("CHAT_ROOM")
                .update(["is_visible":"0"])
                .eq("id", value: chatRoom.id)
                .execute()
        } catch {
            print("Failed to update chat room: \(error)")
        }
    }
    
    // 대화방 대화내용 불러오기
    private func fetchChatLogs(_ id: Int? = nil, chatRoom: ChatRoom, isRefresh: Bool = false) async throws -> [ChatLog] {
        do {
            let component = forChatComponents.filter {
                $0.chatRoom.id == chatRoom.id
            }.first
            
            var preLogs: [ChatLog] = []
            var newLogs: [ChatLog] = []
            
            if isRefresh || id != nil {
                preLogs = component != nil ? component!.chatLogs : preLogs
            }
            
            if let id = id {
                newLogs = try await db
                    .from("CHAT_LOG")
                    .select()
                    .eq("id", value: id)
                    .order("created_at", ascending: false)
                    .execute()
                    .value
            } else {
                newLogs = try await db
                    .from("CHAT_LOG")
                    .select()
                    .eq("chat_room", value: chatRoom.id)
                    .order("created_at", ascending: false) // 내림차순으로 정렬
                    .limit(30)
                    .range(from: preLogs.count, to: preLogs.count + 30)
                    .execute()
                    .value
            }
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
            var chatRoom: ChatRoomPost = ChatRoomPost(user1: userStore.user.id, user2: user)
            if userStore.user.id > user { // 유저 아이디가 낮은 값이 앞으로 가도록 설정
                chatRoom.user1 = user
                chatRoom.user2 = userStore.user.id
            }
            
            try await db.from("CHAT_ROOM")
                .insert(chatRoom)
                .execute()
            
            let enteredChatRooms: [ChatRoom] = try await db.from("CHAT_ROOM")
                .select()
                .eq("user1", value: chatRoom.user1)
                .eq("user2", value: chatRoom.user2)
                .execute()
                .value
                
            if let enteredChatRoom = enteredChatRooms.first {
                self.enteredChatRoom = enteredChatRoom
            } else {
                self.enteredChatRoom = nil
            }
        } catch {
            print("Fail to save chat room: \(error)")
        }
    }
    
    // 대화내용 저장
    func saveChatLog(_ chatRoom: Int, message: String, route: Int?, image: String?) async throws {
        do {
            let chatLog: ChatLogPost = ChatLogPost(writeUser: userStore.user.id, chatRoom: chatRoom, message: message, route: route, image: image)
            try await db.from("CHAT_LOG")
                .insert(chatLog)
                .execute()
        } catch {
            print("Fail to save chat log: \(error)")
        }
    }
    
    func leaveChatRoom(_ chatRoom: ChatRoom) async throws {
        do {
            var chatRoom = chatRoom
            var visible = 0
            
            Task {
                if chatRoom.isVisible == 0 {
                    visible = chatRoom.user1 == userStore.user.id ? 2 : 1
                } else {
                    try await deleteChatRoom(chatRoom)
                    return
                }
                
                chatRoom.isVisible = visible
                
                try await db.from("CHAT_ROOM")
                    .update(["is_visible":"\(visible)"])
                    .eq("id", value: chatRoom.id)
                    .execute()
            }
        }
    }
    
    // 채팅방 삭제
    func deleteChatRoom(_ chatRoom: ChatRoom) async throws {
        do {
            try await db.from("CHAT_LOG").delete().eq("chat_room", value: chatRoom.id).execute()
            try await db.from("CHAT_ROOM").delete().eq("id", value: chatRoom.id).execute()
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
            if year != 0 || month != 0 || day != 0 {
                return dateString
            } else {
                if hour != 0 {
                    return "\(hour)시간 전"
                } else if minute != 0 {
                    return "\(minute)분 전"
                } else {
                    return "방금 전"
                }
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
