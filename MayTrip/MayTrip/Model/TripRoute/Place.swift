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
    //let createdAt: Date
    //let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
                case id
                case name
                case tripRoute = "trip_route"
                case tripDate = "trip_date"
                case ordered
                case coordinates
            }
}

struct PlacePost: Codable{
    let name: String
    let coordinate: [Double]
    let tripRoute: Int
    let tripDate: Date
    let ordered: Int
    let coordinates: [Double]
    let createdAt: Date
}
