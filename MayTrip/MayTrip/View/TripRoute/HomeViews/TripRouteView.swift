//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let dateStore = DateStore.shared
    @StateObject var tripRouteStore: TripRouteStore = TripRouteStore()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    TopContentsView()
                        .padding(.bottom, 8)
                    
                    MyTripCardView()
                        .padding(.bottom, 15)
                    
                    RecommendRouteView()
                }
                .padding(.vertical)
            }
            .padding(.vertical)
            .scrollIndicators(.hidden)
            .toolbar {
                HStack(spacing: 20) {
                    Image("appLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 35)
                    
                    Spacer()
                    
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                    }
                    
                    Button {
                        dateStore.initDate()
                        navigationManager.push(.enterBasicInfo(tripRoute: nil))
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                            .padding(.trailing, UIScreen.main.bounds.width * 0.01)
                    }
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .enterBasicInfo(let tripRoute):
                            EnterBasicInformationView(tripRoute: tripRoute)
                        case .placeAdd(let title, let tags, let tripRoute):
                            PlaceAddingView(title: title, tags: tags, tripRoute: tripRoute)
                        case .routeDetail(let tripRoute):
                            RouteDetailView(tripRoute: tripRoute)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TripRouteView()
}
