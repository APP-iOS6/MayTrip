//
//  ChatRoom.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

struct ChatRoom: Codable, Identifiable, Hashable {
    var id: Int
    var user1: Int
    var user2: Int
    var createdAt: Date
    var updatedAt: Date?
    var isVisible: Int
    
    enum CodingKeys: String,CodingKey {
        case id
        case user1
        case user2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isVisible = "is_visible"
    }
}

struct ChatRoomPost: Codable {
    var user1: Int
    var user2: Int
    var isVisible: Int = 0
    
    enum CodingKeys: String,CodingKey {
        case user1
        case user2
        case isVisible = "is_visible"
    }
}
