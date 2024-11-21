//
//  TripRoute.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation


struct TripRoute: Identifiable ,Codable, Hashable {
    let id : Int
    let title: String
    let tag: [String]
    let city: [String]
    let writeUser: TripRouteUser
    let place: [Place]
    let startDate: String
    let endDate: String
    let created_at: Date
    let updated_at: Date
    
    enum CodingKeys: String,CodingKey {
        case id
        case title
        case tag
        case city
        case writeUser
        case place
        case startDate = "start_date"
        case endDate = "end_date"
        case created_at
        case updated_at
    }
}

struct TripRoutePost: Codable{
    var title: String
    var tag: [String] = []
    var city: [String]
    var writeUser: Int
    var startDate: String
    var endDate: String
    
    enum CodingKeys: String,CodingKey {
        case title
        case tag
        case city
        case writeUser = "write_user"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct TripRouteSimple: Identifiable ,Codable{
    var id: Int
    var title: String
    var tag: [String]?
    var city: [String]
    var startDate: String
    var endDate: String
    var userId: Int? //북마크 한 사람
    var count: Int
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tag
        case city
        case startDate = "start_date"
        case endDate = "end_date"
        case userId = "user_id"
        case count
        case createdAt = "created_at"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.tag = try container.decodeIfPresent([String].self, forKey: .tag)
        self.city = try container.decode([String].self, forKey: .city)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decode(String.self, forKey: .endDate)
        self.userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        self.count = (try? container.decode(Int.self, forKey: .count)) ?? 0
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}

struct TripRouteUser: Codable, Hashable {
    let id: Int
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case profileImage = "profile_image"
    }
}
