//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI
import UIKit

struct MyTripCardView: View {
    @StateObject var tripRouteStore: TripRouteStore = TripRouteStore()
    var dateStore: DateStore = .shared
    let user: User = UserStore.shared.user
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tripRouteStore.myTripRoutes.sorted(by: { $0.start_date < $1.start_date })) { route in
                    if dateStore.convertStringToDate(route.end_date) >= Date() {
                        NavigationLink {
                            // TODO: 디테일 뷰 이동
                            RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(dateStore.isOnATrip(route.start_date, end: route.end_date) ? Color("accentColor") : Color(uiColor: .systemGray6))
                                .overlay {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("\(route.title)")
                                                .font(.system(size: 18, weight: .bold))
                                            
                                            Spacer()
                                        }
                                        .foregroundStyle(dateStore.isOnATrip(route.start_date, end: route.end_date) ? .white : .black)
                                        
                                        HStack(spacing: 0) {
                                            Text("\(dateStore.convertDateToString(dateStore.convertStringToDate(route.start_date), format: "yy.MM.dd(EEEEE)"))")
                                            
                                            if route.end_date != route.start_date {
                                                Text(" - \(dateStore.convertDateToString(dateStore.convertStringToDate(route.end_date), format: "yy.MM.dd(EEEEE)"))")
                                            }
                                        }
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                        
                                        HStack {
                                            // 도시는 최대 두개까지만 보여준다
                                            ForEach(0..<2) { index in
                                                if index < route.city.count {
                                                    Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                                        .lineLimit(1)
                                                }
                                            }
                                        }
                                        .fontWeight(.semibold)
                                    }
                                    .font(.system(size: 15))
                                    .foregroundStyle(dateStore.isOnATrip(route.start_date, end: route.end_date) ? .white : Color(uiColor: .darkGray))
                                    .padding()
                                    .padding(.vertical)
                                }
                                .frame(width: UIScreen.main.bounds.size.width / 8 * 7, height: UIScreen.main.bounds.size.height / 8)
                        }
                        .padding(2)
                    }
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
        .onAppear {
            Task {
                try await tripRouteStore.getCreatedByUserRoutes()
            }
        }
    }
}


#Preview {
    MyTripCardView()
}
