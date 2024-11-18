//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    @StateObject var tripRouteStore: TripRouteStore = TripRouteStore()
    
    var isExist: Bool {
        tripRouteStore.myTripRoutes.count > 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    TopContentsView()
                    
                    if isExist {
                        MyTripCardView(tripRouteStore: tripRouteStore)
                            .padding(.bottom, 10)
                    }
                    
                    RecommendRouteView()
                        .padding(.bottom)
                }
            }
            .padding(.top, 10)
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
                    
                    NavigationLink {
                        EnterBasicInformationView()
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                            .padding(.trailing, UIScreen.main.bounds.width * 0.01)
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await tripRouteStore.getCreatedByUserRoutes()
            }
        }
    }
}

#Preview {
    TripRouteView()
}
