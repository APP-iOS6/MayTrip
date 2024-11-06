//
//  PlaceSearchView.swift
//  MayTrip
//
//  Created by 최승호 on 11/3/24.
//

import SwiftUI

struct PlaceSearchView: View {
    var searchAddressStore = SearchAddressStore.shared
    var locationManager = LocationManager.shared
    var startDate: Date
    var endDate: Date
    @State var keyword: String = ""         // 검색 키워드
    @State var documents: [Document] = []   // 검색 결과 장소 배열
    @Binding var selectedDay: Int             // 장소 추가시에 몇일차에 장소 추가하는지
    @Binding var isShowSheet: Bool          // 장소 추가시트 띄우기
    @Binding var places: [[PlacePost]]          // 추가된 장소 (배열당 한 일차 장소배열)
    @Binding var cities: [String]

    var body: some View {
        VStack {
            TextField("검색어를 입력하세요.", text: $keyword)
                .textInputAutocapitalization(.never)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                .padding(.top, 20)
                .padding(.horizontal)
            
            List(documents) { document in
                VStack(alignment: .leading, spacing: 8) {
                    Text(document.placeName)
                        .font(.headline)
                        .bold()
                    HStack{
                        Text(document.roadAddressName)
                            .font(.subheadline)
                        Spacer()
                        Text(searchAddressStore.getDistance(from: document.distance))
                            .font(.subheadline)
                    }
                }
                .onTapGesture { // 선택한 장소 places[일차] 배열에 추가, 시트 내림
                    // TODO: 이미 선택한 장소 추가할 경우에 시나리오 추가
                    let place = PlacePost(name: document.placeName,
                                          tripDate: selectedDate(from: selectedDay),
                                          ordered: 0,
                                          coordinates: [Double(document.y)!, Double(document.x)!])
                    
                    self.places[selectedDay - 1].append(place)
                    
                    let city = document.addressName.components(separatedBy: " ").first ?? ""    // 결과의 도시부분 추출
                    
                    if !cities.contains(city) { // 존재하지 않은 도시일 경우에 요소 추가
                        self.cities.append(city)
                    }
                    
                    let category = document.categoryGroupName   // 장소 카테고리 이름
//                    print("category: \(category)")
                    
                    isShowSheet.toggle()
                }
            }
            .listStyle(.plain)
        }
        .onChange(of: keyword) {
            Task {
                try await searchAddressStore.getAddresses(query: keyword, coordinate: locationManager.lastKnownLocation!)
                documents = searchAddressStore.documents
            }
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .presentationDragIndicator(.visible)
    }
    
    // 선택된 일차의 날짜를 반환하는 함수
    func selectedDate(from day: Int) -> Date {
        let date = self.datesInRange(from: startDate, to: endDate)
        return date[day - 1]
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
