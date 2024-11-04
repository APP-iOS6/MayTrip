//
//  MarkerItem.swift
//  MayTrip
//
//  Created by 최승호 on 11/3/24.
//
import Foundation
import MapKit

struct MarkerItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
