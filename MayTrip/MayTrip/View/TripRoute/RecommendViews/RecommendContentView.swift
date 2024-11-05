//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI

struct RecommendContentView: View {
    var routeStore: DummyRouteStore = .shared
    let route: DummyTripRoute
    
    var body: some View {
        NavigationLink {
            // 디테일 뷰 이동
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(route.title)")
                        .bold()
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
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
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 2)
            )
            .frame(width: 200, height: 200)
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    var routeStore: DummyRouteStore = .shared
    NavigationStack {
        RecommendContentView(route: routeStore.tripRoutes[2])
    }
}
