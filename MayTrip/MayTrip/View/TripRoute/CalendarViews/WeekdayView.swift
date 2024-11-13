//
//  WeekdayView.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI

struct WeekdayView: View {
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekday, id: \.self) { day in
                Text(day)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(day == "일" ?.red : .black)
            }
        }
    }
}
