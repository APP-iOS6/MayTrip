//
//  PlaceAddingView.swift
//  MayTrip
//
//  Created by 최승호 on 11/1/24.
//

import SwiftUI
import MapKit

/**
 여행 시작날짜와 끝날짜를 Date 인자로 필요로 합니다.
 */
struct PlaceAddingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    var title: String
    var tags: [String]
    var tripRoute: TripRoute?
    
    @State var isShowSheet: Bool = false            // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0                 // 장소 추가시에 몇일차에 장소 추가하는지
    @State var cities: [String] = []                // 추가된 도시
    @State var places: [[PlacePost]] = []           // 추가된 장소 (배열당 한 일차 장소배열)
    @State var focusedDayIndex: Int = 0
    
    let dateStore: DateStore = DateStore.shared
    let userStore: UserStore = UserStore.shared
    
    var body: some View {
        VStack {
            // 상단 버튼, 도시태그 뷰
            PlaceHeaderView(
                cities: cities,
                places: places,
                title: title,
                tags: tags,
                tripRoute: tripRoute
            )
            
            // 맵뷰, 일차별 장소 리스트 뷰
            PlaceMapListView(
                isShowSheet: $isShowSheet,
                selectedDay: $selectedDay,
                places: $places,
                focusedDayIndex: $focusedDayIndex,
                isEditing: true
            )
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("여행루트 작성")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                .foregroundStyle(.black)
            }
            
            ToolbarItem(placement: .confirmationAction) {
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
                        if let tripRoute = tripRoute, tripRoute.writeUser.id == userStore.user.id { // 기존의 루트를 편집하고있고, 작성자 본인일 경우
                            try await tripRouteStore.updateTripRoute(routeId: tripRoute.id, userId: userStore.user.id)
                        } else {
                            try await tripRouteStore.addTripRoute(userId: userStore.user.id)    // 새로운 루트를 생성하고 있거나, 작성자 본인이 아닐경우
                        }
                        tripRouteStore.resetDatas()
                        dateStore.initDate()
                        navigationManager.popToRoot()
                    }
                } label: {
                    Text("완료")
                        .foregroundStyle(PlaceStore.isEmpty(for: places) ? Color.gray : Color("accentColor"))
                }
                .disabled(PlaceStore.isEmpty(for: places))
            }
        }
        .onAppear {
            if let tripRoute = tripRoute {
                let dateRange = DateStore.shared.datesInRange()
                self.places = PlaceStore.convertPlacesToPlacePosts(tripRoute.place, dateRange: dateRange)
                self.cities = tripRoute.city
            }
        }
        .padding(.top)
        .sheet(isPresented: $isShowSheet) {
            PlaceSearchView(
                selectedDay: $selectedDay,
                isShowSheet: $isShowSheet,
                places: $places,
                cities: $cities,
                focusedDayIndex: $focusedDayIndex
            )
        }
    }
}
