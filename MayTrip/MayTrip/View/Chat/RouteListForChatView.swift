//
//  RouteListForChatView.swift
//  MayTrip
//
//  Created by 이소영 on 11/18/24.
//


import SwiftUI

struct RouteListForChatView: View {
    @Binding var selectedRouted: Int?
    let routes: [TripRouteSimple]
    private let gridItems: [GridItem] = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItems, spacing: 0) {
                ForEach(routes) { route in
                    RouteCellForChatView(selectedRouted: $selectedRouted, route: route)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}



