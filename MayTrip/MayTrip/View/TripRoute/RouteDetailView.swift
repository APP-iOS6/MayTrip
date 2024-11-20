//
//  RouteDetailView.swift
//  MayTrip
//
//  Created by 최승호 on 11/5/24.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isShowSheet: Bool = false    // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0         // 장소 추가시에 몇일차에 장소 추가하는지
    @State var places: [[PlacePost]] = []       // 추가된 장소 (배열당 한 일차 장소배열)
    @State var focusedDayIndex: Int = 0
    
    var tripRoute: TripRoute
    let dateStore: DateStore = DateStore.shared
    
    var body: some View {
        VStack {
            // 상단 헤더 뷰
            RouteDetailHeaderView(tripRoute: tripRoute)
            
            // 맵뷰, 일차별 장소 리스트 뷰
            PlaceMapListView(
                isShowSheet: $isShowSheet,
                selectedDay: $selectedDay,
                places: $places,
                focusedDayIndex: $focusedDayIndex,
                isEditing: false,
                tripRoute: tripRoute
            )
        }
        .padding(.top)
        .onAppear {
            let startDate = dateStore.convertStringToLocalDate(tripRoute.startDate)
            let endDate = dateStore.convertStringToLocalDate(tripRoute.endDate)
            dateStore.setTripDates(from: startDate, to: endDate)
            
            let dateRange = dateStore.datesInRange()
            places = PlaceStore.convertPlacesToPlacePosts(tripRoute.place, dateRange: dateRange)
        }
        .toolbar(.hidden)
    }
}

#Preview {
    RouteDetailView(tripRoute: SampleTripRoute.sampleRoute)
}

class SampleTripRoute {
    
    static let sampleRoute = TripRoute(
        id: 0,
        title: "샘플 루트",
        tag: ["태그1", "태그2"],
        city: ["샘플도시1", "샘플도시2", "샘플도시3", "샘플도시4"],
        writeUser: TripRouteUser(
            id: -1,
            nickname: "테스터",
            profileImage: nil
        ),
        place: [
            Place(id: 0,
                  name: "테스트1",
                  tripRoute: 0,
                  tripDate: "2024 11 11",
                  ordered: 1,
                  coordinates: [37.5301, 127.1144],
                  category: "MT1"),
            Place(id: 1,
                  name: "테스트2",
                  tripRoute: 0,
                  tripDate: "2024 11 11",
                  ordered: 2,
                  coordinates: [37.5513, 127.0816],
                  category: "CT1"),
            Place(id: 2,
                  name: "테스트3",
                  tripRoute: 0,
                  tripDate: "2024 11 11",
                  ordered: 3,
                  coordinates: [37.5577, 127.0544],
                  category: "HP8"),
            Place(id: 3,
                  name: "테스트4",
                  tripRoute: 0,
                  tripDate: "2024 11 12",
                  ordered: 1,
                  coordinates: [37.5513, 126.9881],
                  category: "FD6"),
            Place(id: 4,
                  name: "테스트5",
                  tripRoute: 0,
                  tripDate: "2024 11 12",
                  ordered: 2,
                  coordinates: [37.6513, 126.7881],
                  category: "PS3")
        ],
        startDate: "2024 11 11",
        endDate: "2024 11 12",
        created_at: .now,
        updated_at: .now)
}
