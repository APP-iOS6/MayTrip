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
        
        return switch weekday {
        case 1:
             day % 7 == 1
        case 2:
             day % 7 == 0
        case 3:
             day % 7 == 6
        case 4:
             day % 7 == 5
        case 5:
             day % 7 == 4
        case 6:
             day % 7 == 3
        case 7:
             day % 7 == 2
        default:
            false
        }
    }
    
    var textColor: Color {
        if date == dateStore.startDate || date == dateStore.endDate {
            return Color(.white)
        }
        
        return Color(isSunday ? .red : .black).opacity(isCurrentMonthDay ? 1 : 0.3)
    }
    
    var opacity: Double {
        if date == dateStore.startDate || date == dateStore.endDate {
            return 0.3
        }
        
        if dateStore.startDate != nil && dateStore.endDate != nil {
            if date > dateStore.startDate! && date < dateStore.endDate! {
                return 0.3
            }
        }
        
        return 0.0
    }
    
    var isLeftCircle: Bool {
        if dateStore.startDate == nil {
            false
        } else {
            date == dateStore.startDate!
        }
    }
    
    var isRightCircle: Bool {
        if dateStore.endDate == nil {
            false
        } else {
            date == dateStore.endDate!
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 50)
                .background {
                    if isLeftCircle || isRightCircle {
                        Circle()
                            .foregroundStyle(.orange)
                    }
                }
                .cornerRadius(isLeftCircle || isRightCircle ? 25 : 0, corners: isLeftCircle ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight])
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
