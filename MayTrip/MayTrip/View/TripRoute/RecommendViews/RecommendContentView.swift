//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI
import UIKit
import Combine

struct RecommendContentView: View {
    let dateStore: DateStore = .shared
    let route: TripRouteSimple
    
    @ObservedObject var tripRouteStore: TripRouteStore
    @State var isScraped = false
    
    var body: some View {
        NavigationLink {
            RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(uiColor: .systemGray4), lineWidth: 0.5)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 3) {
                            Text("\(route.title)")
                                .lineLimit(1)
                                .bold()
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Button {
                                Task{
                                    var success: Bool = isScraped
                                        ? await tripRouteStore.deleteByRouteId(routeId: route.id)
                                        : await tripRouteStore.insertByRouteId(routeId: route.id)
                                    if success{
                                        isScraped.toggle()
                                    }else{
                                        print("북마크 실패")
                                    }
                                }
                            } label: {
                                Image(systemName: isScraped ? "bookmark.fill" : "bookmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        Text("\(dateStore.convertPeriodToString(route.startDate, end: route.endDate)) 여행")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundStyle(Color(uiColor: .darkGray))
                        
                        HStack {
                            ForEach(0..<3) { index in
                                if index < route.city.count {
                                    Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                        .fontWeight(.semibold)
                                        .font(.footnote)
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
                                            .font(.caption)
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
        .frame(height: UIScreen.main.bounds.size.height / 6)
    }
}

