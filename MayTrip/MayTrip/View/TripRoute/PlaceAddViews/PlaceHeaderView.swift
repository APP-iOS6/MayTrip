//
//  PlaceAddHeaderView.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import SwiftUI

struct PlaceHeaderView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    
    var cities: [String]
    var places: [[PlacePost]]
    var title: String
    var tags: [String]
    var tripRoute: TripRoute?
    
    let dateStore: DateStore = DateStore.shared
    let userStore: UserStore = UserStore.shared
    
    var body: some View {
        headerView
        cityTagsView
    }
    
    // 최상단 'x'버튼, '완료'버튼
    var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.black)
            
            Spacer()
            
            Button {
                //작성한 TripRoute db에 저장하는 로직
                let orderedPlaces = PlaceStore.indexingPlace(places)
                let startDate = dateStore.convertDateToString(dateStore.startDate ?? .now)
                let endDate = dateStore.convertDateToString(dateStore.endDate ?? .now)
                
                tripRouteStore.inputDatas(
                    title: title,
                    tags: tags,
                    places: orderedPlaces.flatMap{ $0 },
                    cities: cities,
                    startDate: startDate,
                    endDate: endDate
                )
                Task {
                    if let tripRoute = tripRoute {
                        if userStore.user.id == tripRoute.writeUser.id {
                            try await tripRouteStore.updateTripRoute(routeId: tripRoute.id, userId: userStore.user.id)
                        } else {
                            try await tripRouteStore.addTripRoute(userId: userStore.user.id)
                        }
                    } else {
                        try await tripRouteStore.addTripRoute(userId: userStore.user.id)
                    }
                    tripRouteStore.resetDatas()
                    dateStore.initDate()
                    navigationManager.popToRoot()
                }
            } label: {
                Text("완료")
                    .padding(8)
            }
            .disabled(PlaceStore.isEmpty(for: places))
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(!PlaceStore.isEmpty(for: places) ? Color(UIColor.tintColor) : Color(UIColor.systemGray5))
            }
            .foregroundStyle(.white)
        }
        .frame(height: 20)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
    
    // 도시 태그 뷰
    var cityTagsView: some View {
        HStack {
            VStack {
                CityTagFlowLayout(spacing: 10) {
                    ForEach(cities, id: \.self) { city in
                        Text("# \(city)")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(Color(UIColor.darkGray))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}
