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
    @Binding var places: [[Place]]      // 추가된 장소 (배열당 한 일차 장소배열)
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
            
            // 중앙 장소 정보
            HStack {
                
                if places.count > 0 {
                    VStack {
                        ForEach(Array(places[dateIndex].enumerated()), id: \.element.createdAt) { placeIndex, place in
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
                        }
                    }
                }
            }
            .padding()
            
            // 하단 '장소추가' 버튼
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
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 100)
    }
    
    // 날짜를 원하는 형식으로 변환하는 함수
    func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd(E)" // 10.26(월) 형식
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return dateFormatter.string(from: date)
    }
}
