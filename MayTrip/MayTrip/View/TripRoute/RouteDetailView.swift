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
    
    var locationManager = LocationManager.shared
    var dateStore = DateStore.shared
    @State var startDate: Date = .now
    @State var endDate: Date = .now
    var tripRoute: TripRoute
    
    @State private var focusedDayIndex: Int = 0  // 현재 포커스된 일차
    @State var isShowSheet: Bool = false    // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0         // 장소 추가시에 몇일차에 장소 추가하는지
    @State var cities: [String] = []        // 추가된 도시
    @State var places: [[PlacePost]] = []       // 추가된 장소 (배열당 한 일차 장소배열)
    @State private var markers: [[MarkerItem]] = []
    @State private var mapRegion = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // 초기 위치
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        VStack {
            headerView
            cityTagsView
            mapView
            placesListView
        }
        .padding(.top)
        .onAppear {
            setupInitialData()
            updateMapForDay(focusedDayIndex)
        }
        .toolbar(.hidden)
    }
        
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
                // TODO: 작성한 TripRoute db에 저장하는 로직
            } label: {
                Text("완료")
                    .padding(8)
            }
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.tint)
            }
            .foregroundStyle(.white)
        }
        .frame(height: 20)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
    

    var cityTagsView: some View {
        HStack {
            VStack {
                CityTagFlowLayout(spacing: 10) {
                    ForEach(tripRoute.city, id: \.self) { city in
                        Text("# \(city)")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(Color(UIColor.darkGray))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
        }
    }
        
    var mapView: some View {
        Map(position: $mapRegion) {
            if places.count > 0 {
                if !places[focusedDayIndex].isEmpty {
                    ForEach(Array(places[focusedDayIndex].enumerated()), id: \.offset) { index, place in
                        Annotation("", coordinate: PlaceStore.shared.getCoordinate(for: place)) {
                            Image(systemName: "\(index + 1).circle.fill")
                                .foregroundStyle(.tint)
                                .font(.title)
                                .background(Circle().fill(.white))
                        }
                    }
                    MapPolyline(coordinates: PlaceStore.shared.getCoordinates(for: places[focusedDayIndex]))
                        .stroke(.blue, style: StrokeStyle(lineWidth: 1, dash: [5, 2], dashPhase: 0))
                }
            }
        }
        .frame(height: 200)
    }
    
    var placesListView: some View {
        ScrollView(.vertical) {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(Array(datesInRange(from: startDate, to: endDate).enumerated()), id: \.element) { dateIndex, date in
                    Section {
                        PlaceInfoView(
                            dateIndex: dateIndex,
                            date: date,
                            isEditing: false,
                            places: $places,
                            isShowSheet: $isShowSheet,
                            selectedDay: $selectedDay
                        )
                        .background(
                            GeometryReader { geo in
                                Color.clear.onChange(of: geo.frame(in: .global).minY) { minY, _ in
                                    if minY < 300 && minY > 250, dateIndex < places.count, focusedDayIndex != dateIndex {
                                        focusedDayIndex = dateIndex
                                        updateMapForDay(focusedDayIndex)
                                    }
                                }
                            }
                        )
                    }
                }
            }
            .padding(.bottom, 350)
        }
    }
    
    // 주어진 날짜 범위의 날짜 배열을 반환하는 함수
    func datesInRange(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = start
        
        while currentDate <= end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    func dateToString(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 로케일 설정 (옵션)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 시간대 설정 (옵션)
        
        return dateFormatter.date(from: date)
    }
    
    func convertPlacesToPlacePosts(_ places: [Place]) -> [[PlacePost]] {
        // 날짜별로 Place 배열을 그룹화하고, ordered 순으로 정렬
        let groupedByDate = Dictionary(grouping: places) { $0.tripDate }
        
        // 날짜별로 정렬된 배열로 변환, ordered 순서에 맞춰 정렬
        let sortedGroupedByDate = groupedByDate.keys.sorted().compactMap { date -> [PlacePost]? in
            if let placeGroup = groupedByDate[date] {
                let sortedPlaceGroup = placeGroup.sorted(by: { $0.ordered < $1.ordered }) // ordered 순으로 정렬
                
                let placePosts = sortedPlaceGroup.map { place in
                    PlacePost(
                        name: place.name,
                        tripRoute: place.tripRoute,
                        tripDate: dateStore.convertStringToDate(place.tripDate),
                        ordered: place.ordered,
                        coordinates: place.coordinates
                    )
                }
                return placePosts
            }
            return nil
        }
        
        return sortedGroupedByDate
    }
    
    private func setupInitialData() {
        places = convertPlacesToPlacePosts(tripRoute.place)
        startDate = dateStore.convertStringToDate(tripRoute.startDate)
        endDate = dateStore.convertStringToDate(tripRoute.endDate ?? tripRoute.startDate)
        
        locationManager.checkLocationAuthorization()
        self.mapRegion = MapCameraPosition.region(
            MKCoordinateRegion(
                center: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 36.6337, longitude: 128.0179), // 초기 위치
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
    }
    
    private func updateMapForDay(_ dayIndex: Int) {
        guard dayIndex < places.count, !places[dayIndex].isEmpty else { return }
        
        let coordinates = PlaceStore.shared.getCoordinates(for: places[dayIndex])
        if let centerCoordinate = coordinates.first {
            mapRegion = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: centerCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
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
                  coordinates: [37.5301, 127.1144]),
            Place(id: 1,
                  name: "테스트2",
                  tripRoute: 0,
                  tripDate: "2024 11 11",
                  ordered: 2,
                  coordinates: [37.5513, 127.0816]),
            Place(id: 2,
                  name: "테스트3",
                  tripRoute: 0,
                  tripDate: "2024 11 11",
                  ordered: 3,
                  coordinates: [37.5577, 127.0544]),
            Place(id: 3,
                  name: "테스트4",
                  tripRoute: 0,
                  tripDate: "2024 11 12",
                  ordered: 1,
                  coordinates: [37.5513, 126.9881]),
            Place(id: 4,
                  name: "테스트5",
                  tripRoute: 0,
                  tripDate: "2024 11 12",
                  ordered: 2,
                  coordinates: [37.6513, 126.7881])
        ],
        startDate: "2024 11 11",
        endDate: "2024 11 12",
        created_at: .now,
        updated_at: .now)
}
