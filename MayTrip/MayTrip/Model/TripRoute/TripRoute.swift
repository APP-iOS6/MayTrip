//
//  TripRoute.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation


struct TripRoute: Codable{
    let id : Int
    let title: String
    let tag: [String]
    let city: [String]
    let writeUser: TripRouteUser
    let place: [Place]
    let startDate: String
    let endDate: String?
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
    var writeUser: User
    var startDate: Date
    var endDate: Date?
}

struct TripRouteSimple: Codable{
    var id: Int
    var title: String
    var tag: [String]?
    var city: [String]
    var start_date: String
    var end_date: String?
}
