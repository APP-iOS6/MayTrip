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
                try await tripRouteStore.getStorageTripRouteList(userId: UserStore.shared.user.id)
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
            }
        }
    }
}

#Preview {
    TripRouteView()
}
