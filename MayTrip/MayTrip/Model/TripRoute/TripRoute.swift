//
//  TripRoute.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

//MARK: - 새로 만든 트립 루트 모델
struct TripRoute: Identifiable ,Codable, Hashable {
    let id: Int
    let title: String
    let tag: [String]?
    let city: [String]
    let writeUser: WriteUser
    let places: [Place]
    let startDate: String
    let endDate: String
    let storageCount: Int
    
    enum CodingKeys: String,CodingKey {
        case id
        case title
        case tag
        case city
        case writeUser = "write_user"
        case places
        case startDate = "start_date"
        case endDate = "end_date"
        case storageCount = "storage_count"
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

struct TripRouteSimple: Codable, Identifiable {
    let id: Int
    let title: String
    let writeUser: Int
    let tag: [String]?
    let city: [String]
    let place_name: String
    let startDate: String
    let endDate: String
    let storageCount: Int
    //let places: [PlaceSimple]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case writeUser = "write_user"
        case tag
        case city
        case place_name
        case startDate = "start_date"
        case endDate = "end_date"
        case storageCount = "storage_count"
    }
}

//struct TripRouteUser: Codable, Hashable {
//    let id: Int
//    let nickname: String
//    let profileImage: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nickname
//        case profileImage = "profile_image"
//    }
//}

struct StorageTripRoute: Codable{
     let id: Int
     let title: String
     let tag: [String]?
     let city: [String]
 }
