//
//  PostComment.swift
//  MayTrip
//
//  Created by 최승호 on 11/24/24.
//

import Foundation

struct PostComment: Codable, Hashable {
    let id: Int
    let writeUser: TripRouteUser
    let comment: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case writeUser = "write_user"
        case comment
        case createdAt = "created_at"
    }
}

struct InsertPostComment: Codable {
    let userId: Int
    let postId: Int
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "write_user"
        case postId = "post"
        case comment
    }
}
