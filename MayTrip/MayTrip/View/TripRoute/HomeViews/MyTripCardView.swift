//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI

struct MyTripCardView: View {
    var dateStore: DateStore = .shared
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
                            .foregroundStyle(routeStore.isOnATrip(route.start_date, end: route.end_date) ? Color("accentColor") : Color(uiColor: .systemGray6))
                            .overlay {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("\(route.title)")
                                            .font(.system(size: 18))
                                        
                                        Spacer()
                                    }
                                    .bold()
                                    
                                    Text("\((dateStore.convertDateToString(route.start_date) != "" && dateStore.convertDateToString(route.end_date) != "") ? "\(dateStore.convertDateToString(route.start_date)) - \(dateStore.convertDateToString(route.end_date))" : (dateStore.convertDateToString(route.start_date) == dateStore.convertDateToString(route.end_date)) ? "" : "당일치기 여행")")
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
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(routeStore.isOnATrip(route.start_date, end: route.end_date) ? .white : .gray)
                                
                                .padding()
                                .padding(.vertical)
                            }
                            .frame(width: 350, height: 100)
                    }
                    .padding(2)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
}


#Preview {
    MyTripCardView()
}
