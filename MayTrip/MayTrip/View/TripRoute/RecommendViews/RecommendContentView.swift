//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI
import UIKit

struct RecommendContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    let dateStore: DateStore = .shared
    let route: TripRouteSimple
    
    @State var isScraped = false
    
    var body: some View {
        Button {
            // 디테일 뷰 이동
            Task {
                try await tripRouteStore.getTripRoute(id: route.id)
                DispatchQueue.main.async {
                    navigationManager.push(.routeDetail(tripRouteStore.tripRoute.first ?? SampleTripRoute.sampleRoute))
                }
            }
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.clear)
                .shadow(radius: 1)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 3) {
                            Text("\(route.title)")
                                .lineLimit(1)
                                .bold()
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Button {
                                isScraped.toggle()
                            } label: {
                                Image(systemName: isScraped ? "bookmark.fill" : "bookmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(isScraped ? .orange : .gray)
                            }
                        }
                        
                        Text("\(dateStore.convertPeriodToString(route.start_date, end: route.end_date)) 여행")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundStyle(Color(uiColor: .darkGray))
                        
                        HStack {
                            ForEach(0..<3) { index in
                                if index < route.city.count {
                                    Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .foregroundStyle(Color(uiColor: .darkGray))
                                }
                            }
                        }
                        
                        HStack {
                            if let tags: [String] = route.tag {
                                ForEach(0..<3) { index in
                                    if index < tags.count {
                                        Text("#\(tags[index]) ")
                                            .lineLimit(1)
                                            .foregroundStyle(Color("accentColor"))
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                )
        }
        .frame(minHeight: UIScreen.main.bounds.size.height / 8)
    }
}

