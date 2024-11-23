//
//  PlaceAddBodyView.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import SwiftUI
import MapKit

struct PlaceMapListView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowSheet: Bool
    @Binding var selectedDay: Int
    @Binding var places: [[PlacePost]]
    @Binding var focusedDayIndex: Int
    
    @State var scrollingIndex: Int = 0
    @State var mapRegion: MapCameraPosition = .automatic
    @State var isShowDatePicker: Bool = false

    var isEditing: Bool
    var tripRoute: TripRoute?
    
    let dateStore: DateStore = DateStore.shared
    let locationManager: LocationManager = LocationManager.shared
    
    @State var heightValue = 300.0
    @State var downHeight = 0.0
    @GestureState var isDragging = false
    let minHeight = 100.0
    let maxHeight = 450.0
    
    var isWriter: Bool {
        if let tripRoute = tripRoute {
            return tripRoute.writeUser.id == UserStore.shared.user.id
        }
        
        return false
    }
    
    var body: some View {
        mapView
            .frame(height: heightValue)
        
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 60, height: 6)
                .foregroundStyle(.gray)
                .padding(.top)
                .gesture(dragHandle)
            
            placesListView
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
        .onAppear {
            setupInitialData()
        }
    }
    
    var placesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(Array(dateStore.datesInRange().enumerated()), id: \.element) { dateIndex, date in
                        PlaceInfoView(
                            dateIndex: dateIndex,
                            date: date,
                            isEditing: isEditing,
                            places: $places,
                            isShowSheet: $isShowSheet,
                            isShowDatePicker: $isShowDatePicker,
                            selectedDay: $selectedDay
                        )
                        .id(dateIndex)
                        .background(
                            GeometryReader { geo in
                                Color.clear.onChange(of: geo.frame(in: .named("scrollView")).minY) { minY, _ in
                                    if minY < 10 && minY > -30, dateIndex < places.count, scrollingIndex != dateIndex {
                                        scrollingIndex = dateIndex
                                        updateMapForDay(dateIndex)
                                    }
                                }
                            }
                        )
                        
                        if isEditing && dateIndex != places.count - 1 {
                            Divider()
                                .foregroundStyle(Color(UIColor.systemGray5))
                                .padding(.horizontal)
                        }
                    }
                    
                    if !isEditing, !isWriter {
                        Button {
                            navigationManager.push(.enterBasicInfo(tripRoute: tripRoute))
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("내 일정으로 담기")
                            }
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accent)
                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                }
                .padding(.bottom, 350)
            }
            .coordinateSpace(name: "scrollView")
            .onChange(of: focusedDayIndex) { index, oldvalue in
                withAnimation {
                    scrollingIndex = oldvalue
                    proxy.scrollTo(oldvalue, anchor: .top)
                }
            }
            .onChange(of: places) { newValue, oldValue in
                // 장소 추가시 인덱스 업데이트, 리스트 스크롤, 지도 갱신
                proxy.scrollTo(selectedDay, anchor: .top)
                
                focusedDayIndex = selectedDay
                scrollingIndex = selectedDay
                
                updateMapForDay(scrollingIndex)
            }
        }
        .sheet(isPresented: $isShowDatePicker) {
            PlaceDatePickerView(
                focusedDayIndex: $focusedDayIndex,
                isShowDatePicker: $isShowDatePicker,
                scrollingIndex: scrollingIndex)
        }
    }
    
    var dragHandle : some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                if isDragging {
                    heightValue = min(maxHeight, max(downHeight + gesture.translation.height, minHeight))
                } else {
                    downHeight = heightValue
                }
            }
            .updating($isDragging) { oldState, newState, transaction in
                newState = true
            }
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
    
    private func setupInitialData() {
        let count = dateStore.datesInRange().count
        if places.isEmpty {
            places = Array(repeating: [], count: count)
        }
        
        locationManager.checkLocationAuthorization()
        if isEditing {
            let initalSpan = MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
            
            self.mapRegion = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 36.6337, longitude: 128.0179), // 초기 위치
                    span: locationManager.lastKnownLocation != nil ? MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) : initalSpan
                )
            )
        }
    }
}
