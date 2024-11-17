//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI
import UIKit

struct MyTripCardView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    var dateStore: DateStore = .shared
    let user: User = UserStore.shared.user
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tripRouteStore.myTripRoutes.sorted(by: { $0.start_date < $1.start_date })) { route in
                    if dateStore.convertStringToDate(route.end_date) >= Date() {
                        Button {
                            Task {
                                try await tripRouteStore.getTripRoute(id: route.id)
                                DispatchQueue.main.async {
                                    navigationManager.push(.routeDetail(tripRouteStore.tripRoute.first ?? SampleTripRoute.sampleRoute))
                                }
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke((dateStore.isOnATrip(route.start_date, end: route.end_date) ? Color("accentColor") : Color(uiColor: .systemGray4)), lineWidth: 0.5)
                                .overlay {
                                    HStack(spacing: 0) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text("\(route.title)")
                                                    .font(.callout)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                            }
                                            .foregroundStyle(.black)
                                            
                                            HStack {
                                                // 도시는 최대 두개까지만 보여준다
                                                ForEach(0..<2) { index in
                                                    if index < route.city.count {
                                                        Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            
                                            HStack(spacing: 0) {
                                                Text("\(dateStore.convertDateToString(dateStore.convertStringToDate(route.start_date), format: "yy.MM.dd"))")
                                                
                                                if route.end_date != route.start_date {
                                                    Text(" - \(dateStore.convertDateToString(dateStore.convertStringToDate(route.end_date), format: "yy.MM.dd"))")
                                                }
                                            }
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .lineLimit(1)
                                        }
                                        .foregroundStyle(Color(uiColor: .darkGray))
                                        .padding()
                                        .padding(.vertical)
                                        
                                        Divider()
                                            .background(.white)
                                            .padding(.vertical)
                                        
                                        Text(dateStore.isOnATrip(route.start_date, end: route.end_date) ? "여행중" : dateStore.calcDDay(route.start_date))
                                            .foregroundStyle(Color("accentColor"))
                                            .padding(.horizontal)
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.size.width / 4 * 3, height: UIScreen.main.bounds.size.height / 9)
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
