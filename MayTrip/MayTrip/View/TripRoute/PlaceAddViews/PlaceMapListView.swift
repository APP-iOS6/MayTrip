//
//  PlaceAddBodyView.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import SwiftUI
import MapKit

struct PlaceMapListView: View {
    @Binding var isShowSheet: Bool
    @Binding var selectedDay: Int
    @Binding var places: [[PlacePost]]
    
    @State var scrollingIndex: Int = 0
    @State var focusedDayIndex: Int = 0
    @State var mapRegion: MapCameraPosition = .automatic
    @State var isShowDatePicker: Bool = false
    var startDate: Date
    var endDate: Date
    var isEditing: Bool
    
    let dateStore: DateStore = DateStore.shared
    let locationManager: LocationManager = LocationManager.shared
    
    var body: some View {
        mapView
        placesListView
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
                            isEditing: isEditing,
                            places: $places,
                            isShowSheet: $isShowSheet,
                            isShowDatePicker: $isShowDatePicker,
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
                
                proxy.scrollTo(selectedDay, anchor: .top)
                
                if oldValue[selectedDay].count == 1 {
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
        .sheet(isPresented: $isShowDatePicker) {
            PlaceDatePickerView(
                focusedDayIndex: $focusedDayIndex,
                isShowDatePicker: $isShowDatePicker,
                startDate: startDate,
                endDate: endDate,
                scrollingIndex: scrollingIndex)
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
        let count = dateStore.datesInRange(from: startDate, to: endDate).count
        if places.isEmpty {
            places = Array(repeating: [], count: count)
        }
        
        locationManager.checkLocationAuthorization()
        self.mapRegion = MapCameraPosition.region(
            MKCoordinateRegion(
                center: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 36.6337, longitude: 128.0179), // 초기 위치
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
    }
}
