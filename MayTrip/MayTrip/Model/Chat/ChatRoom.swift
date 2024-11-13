//
//  ChatRoom.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

struct ChatRoom: Codable, Identifiable {
    var id: Int
    var user1: Int
    var user2: Int
    var createdAt: Date
    var updatedAt: Date?
    
    enum CodingKeys: String,CodingKey {
        case id
        case user1
        case user2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ChatRoomPost: Codable {
    var user1: Int
    var user2: Int
    
    enum CodingKeys: String,CodingKey {
        case user1
        case user2
    }
}
