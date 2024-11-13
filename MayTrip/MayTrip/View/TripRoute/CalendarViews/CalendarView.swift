//
//  CalendarView.swift
//  MayTrip
//
//  Created by 이소영 on 11/1/24.
//
import SwiftUI
import Observation

struct CalendarView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            YearAndMonthView(isShowing: $isShowing)
            
            WeekdayView()
            
            DateGridView()
        }
        .padding()
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 2)
        )
        .background(Color.white)
    }
}

#Preview {
    CalendarView(isShowing: .constant(true))
}
