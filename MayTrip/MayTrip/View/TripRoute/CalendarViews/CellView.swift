//
//  CellView.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI

struct CellView: View {
    var dateStore: DateStore = DateStore.shared
    
    var day: Int
    var date: Date
    var isCurrentMonthDay: Bool

    var isSunday: Bool {
        let weekday: Int = dateStore.firstWeekdayOfMonth(date)
        
        return day % 7 == (9 - weekday) % 7
    }
    
    var textColor: Color {
        guard let startDate = dateStore.startDate, let endDate = dateStore.endDate else {
            return Color(isSunday ? .red : .black).opacity(isCurrentMonthDay ? 1 : 0.3)
        }
        
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        let date = Calendar.current.startOfDay(for: date)
        
        if date == start || date == end {
            return Color(.white)
        }
        
        return Color(isSunday ? .red : .black).opacity(isCurrentMonthDay ? 1 : 0.3)
    }
    
    var opacity: Double {
        guard let startDate = dateStore.startDate, let endDate = dateStore.endDate else {
            return 0.0
        }
        
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        let date = Calendar.current.startOfDay(for: date)

        if date == start || date == end || (date > start && date < end) {
            return 0.3
        }
        return 0.0
    }
    
    var isLeftCircle: Bool {
        guard let startDate = dateStore.startDate else {
            return false
        }
        
        let start = Calendar.current.startOfDay(for: startDate)
        let date = Calendar.current.startOfDay(for: date)
        
        return date == start
    }
    
    var isRightCircle: Bool {
        guard let endDate = dateStore.endDate else {
            return false
        }
        
        let end = Calendar.current.startOfDay(for: endDate)
        let date = Calendar.current.startOfDay(for: date)
        
        return date == end
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 40, height: 40)
                .background {
                    if isLeftCircle || isRightCircle {
                        Circle()
                            .foregroundStyle(.orange)
                    }
                }
                .cornerRadius(isLeftCircle || isRightCircle ? 20 : 0, corners: isLeftCircle && isRightCircle ? [.topRight, .topLeft, .bottomLeft, .bottomRight] : isLeftCircle ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight])
                .foregroundStyle(opacity == 0 ? .clear : .orange.opacity(opacity))
                .overlay(
                    Text("\(day)")
                        .foregroundStyle(textColor)
            )
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
