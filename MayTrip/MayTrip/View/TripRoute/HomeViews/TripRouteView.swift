//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    let dateStore = DateStore.shared
    
    var isExist: Bool {
        tripRouteStore.myTripRoutes.count > 0
    }
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if isExist {
                        MyTripCardView()
                            .padding(.bottom, 10)
                    }
                    
                    RecommendRouteView(background: Color(uiColor: .systemGray6))
                        .padding(.bottom)
                }
            }
            .onAppear {
                Task {
                    try await tripRouteStore.getCreatedByUserRoutes()
                }
            }
            .padding(.top, 10)
            .background(Color(uiColor: .systemGray6))
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
                        Image(systemName: "calendar.badge.plus")
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
                        case .chatRoom(let chatRoom, let user):
                            ChattingRoomView(chatRoom: chatRoom, otherUser: user)
                        case .enterBasic:
                            EnterBasicInformationView()
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
