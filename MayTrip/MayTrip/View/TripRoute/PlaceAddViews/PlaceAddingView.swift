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
    @State var isShowSheet: Bool = false    // 장소 추가시트 띄우기
    @State var selectedDay: Int = 0         // 장소 추가시에 몇일차에 장소 추가하는지
    @State var cities: [String] = []        // 추가된 도시
    @State var places: [[Place]] = []       // 추가된 장소 (배열당 한 일차 장소배열)
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
            // TODO: 작성한 TripRoute db에 저장하는 로직
            
            Button {
                
            } label: {
                Text("다음")
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
                                      places: $places,
                                      isShowSheet: $isShowSheet,
                                      selectedDay: $selectedDay)
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
            // 1. 시작날짜,끝날짜 계산해서 총 몇일인지 구하여 2차원배열 길이 조정
            let count = datesInRange(from: startDate, to: endDate).count
            places = Array(repeating: [], count: count)
            markers = Array(repeating: [], count: count)
            
            // 2. 사용자의 현재위치를 가져옴.
            locationManager.checkLocationAuthorization()
            self.mapRegion = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 36.6337, longitude: 128.0179), // 초기 위치
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
        .sheet(isPresented: $isShowSheet) {
            // 장소 검색 뷰
            PlaceSearchView(startDate: startDate,
                            endDate: endDate,
                            selectedDay: $selectedDay,
                            isShowSheet: $isShowSheet,
                            places: $places,
                            cities: $cities,
                            markers: $markers)
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
}


#Preview {
    let startDate = DateComponents(year: 2024, month: 11, day: 24)
    let endDate = DateComponents(year: 2024, month: 11, day: 29)
    let calendar = Calendar.current
    PlaceAddingView(startDate: calendar.date(from: startDate)!, endDate: calendar.date(from: endDate)!)
}
