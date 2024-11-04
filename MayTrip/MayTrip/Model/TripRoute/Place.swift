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
    let coordinate: [Double]
    //let tripRoute: Int?
    //let visitDate: Date
    //let latitude: Double
    //let longitude: Double
    //let createdAt: Date
    //let updatedAt: Date
}

struct PlacePost: Codable{
    let routeDay: Int
    let name: String
    let coordinate: [Double]
}
