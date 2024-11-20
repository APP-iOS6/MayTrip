//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI

struct MyTripCardView: View {
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @EnvironmentObject var navigationManager: NavigationManager
    var dateStore: DateStore = .shared
    let user: User = UserStore.shared.user
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(tripRouteStore.myTripRoutes.sorted(by: { $0.startDate < $1.startDate })) { route in
                    // 메인 화면에서는 여행중 또는 앞으로 갈 여행만 보여준다
                    if dateStore.convertStringToDate(route.endDate) >= Date() {
                        Button {
                            Task {
                                let route: TripRoute? = await tripRouteStore.getTripRoute(tripId: route.id)
                                DispatchQueue.main.async {
                                    navigationManager.push(.routeDetail(route ?? SampleTripRoute.sampleRoute))
                                }
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("accentColor"), lineWidth: 1)
                                .overlay {
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
                                            
                                            Text(dateStore.isOnATrip(route.startDate, end: route.endDate) ? "여행중" : dateStore.calcDDay(route.startDate))
                                                .font(.caption)
                                                .foregroundStyle(Color("accentColor"))
                                                .padding(.horizontal, 8)
                                                .padding(5)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 20, style: .circular)
                                                        .foregroundStyle(Color("accentColor").opacity(0.15))
                                                }
                                        }
                                        .padding(10)
                                        
                                        Text(route.title)
                                            .font(.title3)
                                            .lineLimit(1)
                                            .bold()
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 10)
                                            .multilineTextAlignment(.leading)
                                        
                                        HStack(spacing: 0) {
                                            Text(dateStore.convertDateToString(dateStore.convertStringToDate(route.startDate), format: "yy.MM.dd"))
                                            
                                            if route.endDate != route.startDate {
                                                Text(" - \(dateStore.convertDateToString(dateStore.convertStringToDate(route.endDate), format: "yy.MM.dd"))")
                                            }
                                        }
                                        .font(.callout)
                                        .foregroundStyle(.gray)
                                        .padding(10)
                                    }
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(1)
                        .frame(minWidth: UIScreen.main.bounds.size.width / 4 * 3, minHeight: UIScreen.main.bounds.size.height / 7.8)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
