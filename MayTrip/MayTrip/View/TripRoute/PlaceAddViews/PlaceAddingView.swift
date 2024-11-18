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
    @EnvironmentObject var navigationManager: NavigationManager
    var title: String
    var tags: [String]
    var tripRoute: TripRoute?
    
    @State var isShowSheet: Bool = false            // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0                 // 장소 추가시에 몇일차에 장소 추가하는지
    @State var cities: [String] = []                // 추가된 도시
    @State var places: [[PlacePost]] = []           // 추가된 장소 (배열당 한 일차 장소배열)
    @State var focusedDayIndex: Int = 0
    
    var body: some View {
        VStack {
            // 상단 버튼, 도시태그 뷰
            PlaceHeaderView(
                cities: cities,
                places: places,
                title: title,
                tags: tags
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
        .toolbar(.hidden)
    }
}
