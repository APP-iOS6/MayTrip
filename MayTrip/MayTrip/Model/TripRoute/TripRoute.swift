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
    let writeUser: TripRouteUser
    var start_date: String
    var end_date: String
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
