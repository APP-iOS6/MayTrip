//
//  User.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct User: Codable, Hashable, Identifiable {
    let id: Int
    let nickname: String
    let profileImage: String?
    let email: String
    let exp: Int
    let provider: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case profileImage = "profile_image"
        case email
        case exp
        case provider
    }
}

struct UserPost: Codable{
    let nickname: String
    let profileImage: String?
    let email: String
    let provider: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImage = "profile_image"
        case email
        case provider
    }
    
}
