//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    @StateObject var tripRouteStore: TripRouteStore = TripRouteStore()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    TopContentsView()
                        .padding(.bottom)
                    
                    MyTripCardView()
                        .padding(.bottom)
                    
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
                            
                    }
                    
                    NavigationLink {
                        EnterBasicInformationView()
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .frame(width: 15, height:  15)
                    }
                }
                .foregroundStyle(Color("accentColor"))
            }
        }
    }
}

#Preview {
    TripRouteView()
}
