//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI

struct RecommendContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    var routeStore: DummyRouteStore = .shared
    let route: DummyTripRoute
    
    var body: some View {
        Button {
            // 디테일 뷰 이동
            navigationManager.push(.routeDetail(SampleTripRoute.sampleRoute))
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: .systemGray6))
                .overlay(
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("\(route.title)")
                                .bold()
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "bookmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color("accentColor"))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(routeStore.convertPeriodToString(route.start_date, end: route.end_date)) 일정")
                            
                            HStack {
                                ForEach(0..<3) { index in
                                    if index < route.cities.count {
                                        Text("\(index == 0 ? route.cities[index] : "·  \(route.cities[index])")")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .foregroundStyle(Color(uiColor: .darkGray))
                        
                        HStack {
                            ForEach(0..<3) { index in
                                if index < route.tags.count {
                                    Text("#\(route.tags[index]) ")
                                        .font(.system(size: 13))
                                        .lineLimit(1)
                                }
                            }
                        }
                        .font(.footnote)
                        .foregroundStyle(Color(uiColor: .darkGray))
                    }
                    .padding()
                )
                .frame(width: 240, height: 200)
        }
    }
}

#Preview {
    NavigationStack {
        RecommendContentView(route: tripRoutes[2])
    }
}
