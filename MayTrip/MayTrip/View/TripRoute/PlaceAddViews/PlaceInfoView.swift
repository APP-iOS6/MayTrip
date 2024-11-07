//
//  PlaceInfoView.swift
//  MayTrip
//
//  Created by 최승호 on 11/3/24.
//

import SwiftUI

struct PlaceInfoView: View {
    var dateIndex: Int
    var date: Date
    var isEditing: Bool
    @Binding var places: [[PlacePost]]      // 추가된 장소 (배열당 한 일차 장소배열)
    @Binding var isShowSheet: Bool      // 장소 추가시트 띄우기
    @Binding var selectedDay: Int       // 장소 추가시에 몇일차에 장소 추가하는지

    var body: some View {
        VStack(alignment: .leading) {
            // 상단 날짜 정보
            HStack {
                Text("DAY\(dateIndex + 1)")
                    .bold()
                Text(dateString(from: date))
                    .foregroundStyle(.gray)
            }
            .font(.system(size: 14))
            .padding([.horizontal, .top])
            
            // 중앙 장소 정보
                
                if places.count > 0 {
                    List {
                        ForEach(Array(places[dateIndex].enumerated()), id: \.element.coordinates) { placeIndex, place in
                            HStack {
                                // 좌측 번호 영역
                                VStack {
                                    Image(systemName: "\(placeIndex + 1).circle.fill")
                                }
                                
                                // 우측 장소 카드 영역
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(place.name)")
                                        .font(.system(size: 16))
                                        .bold()
                                    
                                    Text("관광명소 | 예약가능")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                                }
                                .padding(.leading)
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            places[dateIndex].remove(atOffsets: indexSet)   // 리스트 내 장소정보 삭제
                        }
                        .onMove { (source: IndexSet, destination: Int) -> Void in
                            self.places[dateIndex].move(fromOffsets: source, toOffset: destination)
                        }
                        .deleteDisabled(!isEditing)
                        .moveDisabled(!isEditing)
                    }
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    .frame(height: CGFloat(places[dateIndex].count) * 90)   // scrollview 내에 list를 넣게되어 리스트뷰 높이를 지정
                }

            
            // 하단 '장소추가' 버튼
            if isEditing {
                Button {
                    isShowSheet.toggle()
                    self.selectedDay = dateIndex + 1
                } label: {
                    Text("장소 추가")
                        .foregroundStyle(Color.primary)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
    }
    
    // 날짜를 원하는 형식으로 변환하는 함수
    func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd(E)" // 10.26(월) 형식
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return dateFormatter.string(from: date)
    }
}
