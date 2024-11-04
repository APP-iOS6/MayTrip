//
//  RouteDay.swift
//  MayTrip
//
//  Created by 권희철 on 11/4/24.
//

import Foundation

struct RouteDay: Codable {
    let id: Int
    let tripDate: Date
    let places: [Place]
}d

struct RouteDayPost: Codable{
    let tripDate: Date
    let tripRoute: Int
    let places: [Place]
}
