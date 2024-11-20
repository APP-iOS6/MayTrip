//
//  SearchRootView.swift
//  MayTrip
//
//  Created by 이소영 on 11/20/24.
//
import SwiftUI

struct SearchRootView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var tripRouteStore: TripRouteStore
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ScrollView {
                LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10) {
                    if tripRouteStore.filteredTripRoutes.count == 0 {
                        Text("검색 결과가 없습니다")
                            .foregroundStyle(.gray)
                    } else {
                        ForEach(tripRouteStore.filteredTripRoutes) { route in
                            RecommendContentView(route: route)
                                .navigationDestination(for: Destination.self) { destination in
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
        .padding(.vertical)
    }
}
