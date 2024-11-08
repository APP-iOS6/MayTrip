//
//  DateGridView.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI

struct DateGridView: View {
    var dateStore: DateStore = DateStore.shared
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var daysInMonth: Int {
        dateStore.numberOfDays()
    }
    
    var firstWeekday: Int {
        dateStore.firstWeekdayOfMonth(dateStore.date) - 1
    }
    
    var lastDayOfMonthBefore: Int {
        dateStore.numberOfDays(true)
    }
    
    var numberOfRows: Int {
        Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
    }
    
    var visibleDaysOfNextMonth: Int {
        numberOfRows * 7 - (daysInMonth + firstWeekday)
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(-firstWeekday..<daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                if index > -1 && index < daysInMonth {
                    let date = dateStore.getDate(index)
                    let day = Calendar.current.component(.day, from: date)
                    
                    CellView(day: day, date: date, isCurrentMonthDay: true)
                        .onTapGesture {
                            dateStore.setTripDates(date)
                        }
                } else if let prevMonthDate = Calendar.current.date(
                    byAdding: .day,
                    value: index + lastDayOfMonthBefore,
                    to: dateStore.previousMonth()
                  ) {
                    let day = Calendar.current.component(.day, from: prevMonthDate)
                    
                    CellView(day: day, date: prevMonthDate, isCurrentMonthDay: false)
                }
            }
        }
        .frame(width: 280)
        .padding(.bottom, 5)
    }
}
