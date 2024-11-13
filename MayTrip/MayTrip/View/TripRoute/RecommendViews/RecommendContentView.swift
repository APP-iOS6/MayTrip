//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI
import UIKit

struct RecommendContentView: View {
    let dateStore: DateStore = .shared
    let route: TripRouteSimple
    
    var body: some View {
        NavigationLink {
            // 디테일 뷰 이동
            RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
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
                            Text("\(dateStore.convertPeriodToString(route.start_date, end: route.end_date)) 여행")
                                .lineLimit(1)
                            
                            HStack {
                                ForEach(0..<3) { index in
                                    if index < route.city.count {
                                        Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .foregroundStyle(Color(uiColor: .darkGray))
                        
                        HStack {
                            if let tags: [String] = route.tag {
                                ForEach(0..<3) { index in
                                    if index < tags.count {
                                        Text("#\(tags[index]) ")
                                            .font(.system(size: 13))
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .font(.footnote)
                        .foregroundStyle(Color(uiColor: .darkGray))
                    }
                    .padding()
                )
                .frame(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.height / 5)
        }
    }
}

