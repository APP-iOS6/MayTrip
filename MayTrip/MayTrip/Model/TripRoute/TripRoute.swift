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
    let writeUser: User
    let Place: [Place]
    let start_date: Date
    let end_date: Date?
    let created_at: Date
    let updated_at: Date
}

struct TripRoutePost: Codable{
    var title: String
    var tag: [String] = []
    var city: [String]
    var writeUser: User
    var startDate: Date
    var endDate: Date?
}
