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
    
    var locationManager = LocationManager.shared
    var startDate: Date
    var endDate: Date
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
        .sheet(isPresented: $isShowSheet) {
            PlaceSearchView(
                startDate: startDate,
                endDate: endDate,
                selectedDay: $selectedDay,
                isShowSheet: $isShowSheet,
                places: $places,
                cities: $cities
            )
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
                    ForEach(cities, id: \.self) { city in
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
                            isEditing: true,
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
    
    private func setupInitialData() {
        let count = datesInRange(from: startDate, to: endDate).count
        places = Array(repeating: [], count: count)
        markers = Array(repeating: [], count: count)
        
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
    let startDate = DateComponents(year: 2024, month: 11, day: 24)
    let endDate = DateComponents(year: 2024, month: 11, day: 29)
    let calendar = Calendar.current
    PlaceAddingView(startDate: calendar.date(from: startDate)!, endDate: calendar.date(from: endDate)!)
}

class PlaceStore {
    static let shared = PlaceStore()
    
    func getCoordinate(for place: PlacePost) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: place.coordinates[0], longitude: place.coordinates[1])
    }
    
    func getCoordinates(for place: [PlacePost]) -> [CLLocationCoordinate2D] {
        place.map{ CLLocationCoordinate2D(latitude: $0.coordinates[0], longitude: $0.coordinates[1]) }
    }
    
    func getPlace(for date: Date, places: [PlacePost]) -> [PlacePost]? {
        places.filter{ $0.tripDate == date }
    }
}
