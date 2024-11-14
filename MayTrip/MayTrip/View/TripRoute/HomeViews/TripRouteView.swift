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
                    
                    NavigationLink {
                        EnterBasicInformationView()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    TripRouteView()
}
