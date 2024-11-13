//
//  RouteListCellView.swift
//  MayTrip
//
//  Created by 이소영 on 11/11/24.
//

import SwiftUI
import UIKit

struct RouteListCellView: View {
    let dateStore: DateStore = DateStore.shared
    let route: TripRouteSimple
    
    var body: some View {
        NavigationLink {
            RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: .systemGray6))
                .overlay {
                    HStack(alignment: .top, spacing: 15) {
                        if let image = route.writeUser.profileImage, image != "" {
                            // TODO: 이미지 띄우기
                            Image(systemName: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(route.writeUser.nickname)님의 여행")
                                .lineLimit(1)
                                .font(.system(size: 15))
                            
                            Text("\(route.title)")
                                .lineLimit(1)
                                .font(.system(size: 17, weight: .semibold))
                            
                            HStack(spacing: 0) {
                                Text("\(dateStore.convertDateToString(dateStore.convertStringToDate(route.start_date), format: "yy.MM.dd(EEEEE)"))")
                                
                                if route.end_date != route.start_date {
                                    Text(" - \(dateStore.convertDateToString(dateStore.convertStringToDate(route.end_date), format: "yy.MM.dd(EEEEE)"))")
                                }
                            }
                            .font(.system(size: 15))
                            
                            HStack {
                                // 도시는 최대 두개까지만 보여준다
                                ForEach(0..<2) { index in
                                    if index < route.city.count {
                                        Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .font(.system(size: 17))
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bookmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color("accentColor"))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 5)
                .foregroundStyle(.black)
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 6)
    }
}
