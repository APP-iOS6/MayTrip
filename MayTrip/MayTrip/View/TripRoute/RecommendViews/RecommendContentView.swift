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
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    let dateStore: DateStore = .shared
    let route: TripRouteSimple
    
    @State var isScraped = false
    
    var body: some View {
        Button {
            // 디테일 뷰 이동
            Task {
                try await tripRouteStore.getTripRoute(tripId: route.id)
                DispatchQueue.main.async {
                    navigationManager.push(.routeDetail(tripRouteStore.tripRoute.first ?? SampleTripRoute.sampleRoute))
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    // 첫번째 도시만 보여준다
                    Text(route.city[0])
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .foregroundStyle(.black)
                        }
                    
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
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .padding(5)
                            .foregroundStyle(.white)
                            .background(isScraped ? .orange : .gray)
                            .clipShape(Circle())
                    }
                }
                .padding(10)
                
                Text(route.title)
                    .font(.title3)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .multilineTextAlignment(.leading)
                
                Text("\(dateStore.convertPeriodToString(route.startDate, end: route.endDate)) 여행")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
                
                Spacer()
                
                HStack {
                    if let tags: [String] = route.tag {
                        ForEach(0..<2) { index in
                            if index < tags.count {
                                Text("#\(tags[index]) ")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                                    .padding(.horizontal, 8)
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20, style: .circular)
                                            .foregroundStyle(.orange.opacity(0.15))
                                    }
                            }
                        }
                    }
                }
                .padding(10)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

