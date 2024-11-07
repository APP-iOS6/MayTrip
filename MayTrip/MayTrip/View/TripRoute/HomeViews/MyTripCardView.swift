//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI

struct MyTripCardView: View {
    var routeStore: DummyRouteStore = .shared
    let name: String = signedUser.nickname
    // TODO: DB 연결해서 데이터 넣기
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<routeStore.createdRoutes.count, id: \.self) { index in
                    let route = routeStore.createdRoutes[index]
                    
                    NavigationLink {
                        // TODO: 디테일 뷰 이동
                        RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(routeStore.isOnATrip(route.start_date, end: route.end_date) ? Color(uiColor: .tintColor) : Color(uiColor: .systemGray6))
                            .overlay {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 10) {
                                                HStack {
                                                    Text("\(route.title)")
                                                    
                                                    Spacer()
                                                }
                                                .bold()
                                                
                                                VStack(alignment: .leading, spacing: 5) {
                                                    
                                                    Text("\(name)님의 \(routeStore.convertPeriodToString(route.start_date, end: route.end_date))여행")
                                                        .font(.system(size: 15))
                                                        .lineLimit(1)
                                                    
                                                    HStack {
                                                        ForEach(0..<3) { index in
                                                            if index < route.cities.count {
                                                                Text("\(index == 0 ? route.cities[index] : "·  \(route.cities[index])")")
                                                                    .lineLimit(1)
                                                            }
                                                        }
                                                    }
                                                    .fontWeight(.semibold)
                                                    
                                                    HStack {
                                                        ForEach(0..<3) { index in
                                                            if index < route.tags.count {
                                                                Text("#\(route.tags[index]) ")
                                                                    .font(.system(size: 13))
                                                                    .lineLimit(1)
                                                            }
                                                        }
                                                    }
                                                }
                                                .font(.system(size: 15))
                                                .foregroundStyle(routeStore.isOnATrip(route.start_date, end: route.end_date) ? .white : .gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        // 현재 여행 중인 카드만 진한 컬러로
                                        .foregroundStyle(routeStore.isOnATrip(route.start_date, end: route.end_date) ? .white : .black)
                                        .padding()
                                        .padding(.vertical)
                            }
                            .frame(width: 350, height: 120)
                    }
                    .padding(2)
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
}


#Preview {
    MyTripCardView()
}
