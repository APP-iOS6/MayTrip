//
//  CalendarView.swift
//  MayTrip
//
//  Created by 이소영 on 11/1/24.
//
import SwiftUI
import Observation

struct CalendarView: View {
    var body: some View {
        VStack {
            YearAndMonthView()
            
            WeekdayView()
            
            DateGridView()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black.opacity(0.3), lineWidth: 2)
        )
    }
}

#Preview {
    CalendarView()
}
