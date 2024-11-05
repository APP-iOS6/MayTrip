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
        HStack {    // 소영님이 작성하신 상단 뷰 영역입니다. 나중에 subView로 빼서 써도될거같아요. 수평패딩만 추가되었습니다.
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.black)
            
            Spacer()
            // TODO: TripRoute 편집화면으로 이동하는 로직 추가
            
            Button {
                
            } label: {
                Text("편집")
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

        HStack{
            VStack {
                CityTagFlowLayout(spacing: 10) {
                    ForEach(cities, id: \.self) { city in
                        Text("# \(city)")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(Color(UIColor.darkGray))
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.systemGray5))
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .padding(.top)
        
        ScrollView(.vertical) {
            LazyVStack(pinnedViews: [.sectionHeaders]){
                ForEach(Array(datesInRange(from: startDate, to: endDate).enumerated()), id: \.element) { dateIndex, date in
                    Section {
                        // 일차별 장소 카드 뷰
                        PlaceInfoView(dateIndex: dateIndex,
                                      date: date,
                                      isEditing: false,
                                      places: $places,
                                      markers: $markers,
                                      isShowSheet: $isShowSheet,
                                      selectedDay: $selectedDay)
                        .padding(.bottom)
                    } header: {
                        Map(position: $mapRegion) {
                            if markers.count > 0 {
                                ForEach(Array(markers[dateIndex].enumerated()), id: \.element.id) { markerIndex, marker in
                                    Annotation("", coordinate: marker.coordinate) {
                                        Image(systemName: "\(markerIndex + 1).circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                        }
                        .frame(height: 300)
                        .mapControlVisibility(.hidden)
                    }
                }
            }
        }
        .padding(.top)
        .onAppear {
            // 임시
            startDate = dateToString(tripRoute.startDate)!
            endDate = dateToString(tripRoute.endDate!)!
            (places, markers) = groupPlacesToPlacePostAndMarkersByDate(tripRoute.place)
            
            // 2. 사용자의 현재위치를 가져옴.
            locationManager.checkLocationAuthorization()
            self.mapRegion = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 36.6337, longitude: 128.0179), // 초기 위치
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 로케일 설정 (옵션)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 시간대 설정 (옵션)
        
        return dateFormatter.date(from: date)
    }
    
    func groupPlacesToPlacePostAndMarkersByDate(_ places: [Place]) -> ([[PlacePost]], [[MarkerItem]]) {
        // 1. tripDate 문자열을 기준으로 그룹화하여 딕셔너리 생성
        let groupedDict = Dictionary(grouping: places, by: { $0.tripDate })
        
        // 2. 날짜 문자열을 Date 객체로 변환하여 정렬된 날짜 문자열 배열 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let sortedDateStrings = groupedDict.keys.sorted { dateStr1, dateStr2 in
            if let date1 = dateFormatter.date(from: dateStr1),
               let date2 = dateFormatter.date(from: dateStr2) {
                return date1 < date2
            } else {
                return dateStr1 < dateStr2
            }
        }
        
        // 3. 정렬된 날짜를 사용하여 [[PlacePost]]와 [[MarkerItem]] 생성
        var groupedPlacePosts: [[PlacePost]] = []
        var groupedMarkers: [[MarkerItem]] = []
        
        for dateString in sortedDateStrings {
            if let placesForDate = groupedDict[dateString],
               let tripDate = dateToString(dateString) {
                // Place를 PlacePost로 변환하고 ordered로 정렬
                let placePosts = placesForDate.map { place -> PlacePost in
                    PlacePost(
                        name: place.name,
                        tripRoute: place.tripRoute,
                        tripDate: tripDate,
                        ordered: place.ordered,
                        coordinates: place.coordinates
                    )
                }.sorted { $0.ordered < $1.ordered }
                groupedPlacePosts.append(placePosts)
                
                // PlacePost를 기반으로 MarkerItem 생성
                let markers = placePosts.map { placePost -> MarkerItem in
                    let coordinate = CLLocationCoordinate2D(
                        latitude: placePost.coordinates[0],
                        longitude: placePost.coordinates[1]
                    )
                    let marker = MarkerItem(coordinate: coordinate)
                    return marker
                }
                groupedMarkers.append(markers)
            } else {
                // 날짜 변환 실패 시 처리 (필요에 따라 작성)
                print("날짜 변환 실패 또는 데이터 없음: \(dateString)")
            }
        }
        
        return (groupedPlacePosts, groupedMarkers)
    }
}

#Preview {
    RouteDetailView(tripRoute: TripRoute(
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
                  coordinates: [37.5513, 126.9881])
        ],
        startDate: "2024 11 11",
        endDate: "2024 11 12",
        created_at: .now,
        updated_at: .now)
    )
}
