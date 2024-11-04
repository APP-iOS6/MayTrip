//
//  Place.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//
import Foundation

struct Place: Identifiable {
    let id: Int?
    let name: String
    let tripRoute: Int?
    let visitDate: Date
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updatedAt: Date
}
