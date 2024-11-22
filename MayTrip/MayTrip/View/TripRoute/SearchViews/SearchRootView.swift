//
//  SearchRootView.swift
//  MayTrip
//
//  Created by 이소영 on 11/20/24.
//
import SwiftUI

struct SearchRootView: View {
    @ObservedObject var tripRouteStore: TripRouteStore
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10) {
                ForEach(tripRouteStore.filteredTripRoutes) { route in
                    RecommendContentView(route: route)
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .padding(.vertical)
    }
}
