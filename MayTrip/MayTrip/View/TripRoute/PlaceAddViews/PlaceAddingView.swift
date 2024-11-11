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
    
    let userStore: UserStore = UserStore.shared
    @StateObject var tripStore: TripRouteStore = TripRouteStore()
    let dateStore: DateStore = DateStore.shared
    let locationManager: LocationManager = LocationManager.shared
    
    var title: String
    var tags: [String]
    var startDate: Date
    var endDate: Date
    @State private var scrollingIndex: Int = 0
    @State private var focusedDayIndex: Int = 0  // 현재 포커스된 일차
    @State private var selectedDate: Date? = nil // 사용자가 선택한 날짜
    @State var isShowDatePickerSheet: Bool = false // 날짜 선택 시트 표시 여부
    @State var isShowSheet: Bool = false    // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0         // 장소 추가시에 몇일차에 장소 추가하는지
    @State var cities: [String] = []        // 추가된 도시
    @State var places: [[PlacePost]] = []       // 추가된 장소 (배열당 한 일차 장소배열)
    @State private var mapRegion: MapCameraPosition = .automatic
    
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
                //작성한 TripRoute db에 저장하는 로직
                let orderedPlaces = PlaceStore.indexingPlace(places)
                tripStore.inputDatas(
                    title: title,
                    tags: tags,
                    places: orderedPlaces.flatMap{ $0 },
                    cities: cities,
                    startDate: dateStore.convertDateToSimpleString(startDate),
                    endDate: dateStore.convertDateToSimpleString(endDate))
                Task {
                    try await tripStore.addTripRoute(userId: userStore.user.id)
                    tripStore.resetDatas()
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
                if !places[scrollingIndex].isEmpty {
                    ForEach(Array(places[scrollingIndex].enumerated()), id: \.offset) { index, place in
                        Annotation("", coordinate: PlaceStore.getCoordinate(for: place)) {
                            Image(systemName: "\(index + 1).circle.fill")
                                .foregroundStyle(.tint)
                                .font(.title)
                                .background(Circle().fill(.white))
                        }
                    }
                    MapPolyline(coordinates: PlaceStore.getCoordinates(for: places[scrollingIndex]))
                        .stroke(.blue, style: StrokeStyle(lineWidth: 1, dash: [5, 2], dashPhase: 0))
                }
            }
        }
        .frame(height: 200)
    }
    
    var placesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(Array(dateStore.datesInRange(from: startDate, to: endDate).enumerated()), id: \.element) { dateIndex, date in
                        PlaceInfoView(
                            dateIndex: dateIndex,
                            date: date,
                            isEditing: true,
                            places: $places,
                            isShowSheet: $isShowSheet,
                            isShowDatePicker: $isShowDatePickerSheet,
                            selectedDay: $selectedDay
                        )
                        .id(dateIndex)
                        .background(
                            GeometryReader { geo in
                                Color.clear.onChange(of: geo.frame(in: .global).minY) { minY, _ in
                                    if minY < 380 && minY > 340, dateIndex < places.count, scrollingIndex != dateIndex {
                                        scrollingIndex = dateIndex
                                        updateMapForDay(dateIndex)
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.bottom, 350)
            }
            .onChange(of: focusedDayIndex) { index, oldvalue in
                withAnimation {
                    scrollingIndex = oldvalue
                    proxy.scrollTo(oldvalue, anchor: .top)
                }
            }
            .onChange(of: places) { newValue, oldValue in
                print("selected Day: \(selectedDay)")
                
                proxy.scrollTo(selectedDay, anchor: .top)
                
                if oldValue[selectedDay].count == 1 {
                    print("have one item")
                    let coordinates: [Double] = places[selectedDay].first?.coordinates ?? [0,0]
                    self.mapRegion = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: coordinates[0],
                                longitude: coordinates[1]), // 초기 위치
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        ))
                } else {
                    mapRegion = .automatic
                }
                
                focusedDayIndex = selectedDay
                scrollingIndex = selectedDay
            }
        }
        .sheet(isPresented: $isShowDatePickerSheet) {
            datePickerSheet
        }
    }
    
    var datePickerSheet: some View {
        VStack(alignment: .leading) {
            Text("날짜 선택")
                .font(.headline)
                .padding([.top, .horizontal])
                .padding([.top, .horizontal])
            
            List {
                ForEach(Array(dateStore.datesInRange(from: startDate, to: endDate).enumerated()), id: \.element) { index, date in
                    Button {
                        focusedDayIndex = index
                        isShowDatePickerSheet = false
                    } label: {
                        HStack {
                            Text("Day\(index+1) \(dateStore.dateToString(with: "MM.dd(E)", date: date))")
                                .foregroundStyle(.primary)
                            if index == focusedDayIndex {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                        .foregroundStyle(index == focusedDayIndex ? .accent : Color.primary)
                        .padding(.horizontal)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .presentationDetents([.medium])
        }
        .onAppear {
            focusedDayIndex = scrollingIndex
        }
    }
    
    private func setupInitialData() {
        let count = dateStore.datesInRange(from: self.startDate, to: self.endDate).count
        places = Array(repeating: [], count: count)
        
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
        
        if places[dayIndex].count == 1 {
            let coordinates: [Double] = places[dayIndex].first?.coordinates ?? [0,0]
            self.mapRegion = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinates[0],
                        longitude: coordinates[1]), // 초기 위치
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        } else {
            self.mapRegion = .automatic
        }
    }
}


#Preview {
    let startDate = DateComponents(year: 2024, month: 11, day: 24)
    let endDate = DateComponents(year: 2024, month: 11, day: 29)
    let calendar = Calendar.current
    PlaceAddingView(
        title: "title",
        tags: ["tag1", "tag2"],
        startDate: calendar.date(from: startDate)!,
        endDate: calendar.date(from: endDate)!
    )
}
