//
//  ChatLog.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

struct ChatLog: Codable, Identifiable {
    let id: Int
    let writeUser: Int
    let chatRoom: Int
    let message: String
    let route: Int?
    let image: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case writeUser = "write_user"
        case chatRoom = "chat_room"
        case message
        case route
        case image
        case createdAt = "created_at"
    }
}

struct ChatLogPost: Codable {
    let writeUser: Int
    let chatRoom: Int
    let message: String
    let route: Int?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case writeUser = "write_user"
        case chatRoom = "chat_room"
        case message
        case route
        case image
    }
}
