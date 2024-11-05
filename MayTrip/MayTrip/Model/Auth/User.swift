//
//  User.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

struct User: Codable {
    
}

struct TripRouteUser: Codable{
    let id: Int
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case profileImage = "profile_image"
    }
}
