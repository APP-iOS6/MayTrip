//
//  RecruitmentNoticeView.swift
//  MayTrip
//
//  Created by 이소영 on 11/18/24.
//


import SwiftUI

// TODO: 루트 공유 만들기
struct RecruitmentNoticeView: View {
    let dateStore: DateStore = .shared
    let route: TripRouteSimple
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(.gray, lineWidth: 1)
            .overlay {
                // storke 쓰면 배경색이 안먹혀서 사각형 한번 더 그려줌
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: .systemGray6))
                    .overlay {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(route.title)")
                                    .lineLimit(1)
                                    .bold()
                                
                                HStack(spacing: 10) {
                                    // 여행지
                                    ForEach(0..<3) { index in
                                        if index < route.city.count {
                                            Text("\(index == 0 ? route.city[index] : "·  \(route.city[index])")")
                                                .lineLimit(1)
                                        }
                                    }
                                    // 여행 날짜, 기간
                                    Text("\(dateStore.convertPeriodToString(route.start_date, end: route.end_date))여행")
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                        // 현재 여행 중인 카드만 진한 컬러로
                        .foregroundStyle(.black)
                        //                            .foregroundStyle(.white)
                        .padding()
                        .padding(.vertical)
                    }
            }
            .padding([.horizontal, .top])
            .background {
                Rectangle()
                    .foregroundColor(.white)
            }
            .padding(.bottom)
            .frame(width: .infinity, height: 130)
    }
}
