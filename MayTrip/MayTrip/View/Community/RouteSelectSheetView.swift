//
//  RouteSelectSheetView.swift
//  MayTrip
//
//  Created by 최승호 on 11/23/24.
//

import SwiftUI

struct RouteSelectSheetView: View {
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @Binding var selectedRouteID: Int?
    @Binding var isShowingRouteSheet: Bool
    
    var body: some View {
        VStack {
            Text("내 여행루트 선택하기")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            if tripRouteStore.myTripRoutes.count > 1 {
                ScrollView(.vertical) {
                    ForEach(tripRouteStore.myTripRoutes) { route in
                        RecommendContentView(route: route, isSharing: true)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent)
                            }
                            .padding(1)
                            .padding([.bottom, .horizontal])
                            .onTapGesture {
                                selectedRouteID = route.id
                                isShowingRouteSheet.toggle()
                            }
                    }
                }
            } else {
                Spacer()
                Text("아직 작성한 여행루트가 없습니다")
                    .foregroundStyle(.gray)
                Spacer()
            }
        }
        .padding(.top)
    }
}
