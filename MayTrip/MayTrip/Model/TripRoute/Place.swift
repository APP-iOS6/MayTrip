//
//  Place.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

struct Place: Codable, Identifiable {
    let id: Int
    let name: String
    let tripRoute: Int
    let tripDate: String
    let ordered: Int
    let coordinates: [Double]
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tripRoute = "trip_route"
        case tripDate = "trip_date"
        case ordered
        case coordinates
        case category
    }
}

struct PlacePost: Codable{
    let name: String
    var tripRoute: Int = 0
    let tripDate: Date
    var ordered: Int
    let coordinates: [Double]
    let categoryCode: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case tripRoute = "trip_route"
        case tripDate = "trip_date"
        case ordered
        case coordinates
        case categoryCode = "category"
    }
}
