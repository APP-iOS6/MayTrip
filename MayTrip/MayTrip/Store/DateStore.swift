//
//  DateStore.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI
import Observation

@Observable
class DateStore {
    static let shared: DateStore = DateStore()
    // TODO: 여행 날짜 수정하는 경우엔 원래 있던 데이터를 가져오도록 수정해야함
    private(set) var date: Date = .init()
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM d"
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }
    
    var currentYear: Int {
        Calendar.current.component(.year, from: date)
    }
    
    var currentMonth: Int {
        Calendar.current.component(.month, from: date)
    }
    
    var currentDay: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var currentDate: Date {
        formatter.date(from: "\(currentYear) \(currentMonth) \(currentDay)") ?? .init()
    }
    
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    
    init() {
        
    }
    
    // 해당 월의 일 수 (윤년 때문에 연도도 필요)
    func numberOfDays(_ isPreviousMonth: Bool = false) -> Int {
        var date: Date = .init()
        date = isPreviousMonth ? previousMonth() : self.date
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 해당 월의 시작하는 요일 찾음
    func firstWeekdayOfMonth(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    // 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
    }
    
    // 특정 해당 날짜
    func getDate(_ index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: date),
                month: calendar.component(.month, from: date),
                day: 1
            )
        ) else {
            return Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = index
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }

    
    // 셀 누를때 여행 시작 날짜, 끝나는 날짜 설정
    func setTripDates(_ date: Date) {
        if let startDate = startDate {
            endDate = date
            
            if startDate > date {
                endDate = startDate
                self.startDate = date
            }
            
            // 여행 시작일이 토글될 때 여행 날짜 재설정 되도록
            if startDate == date {
                self.startDate = nil
                endDate = nil
            }
        } else {
            startDate = date
        }
    }
    
    func forwardMonth() {
        let newYear: Int = currentMonth == 1 ? currentYear - 1 : currentYear
        let newMonth: Int = currentMonth == 1 ? 12 : currentMonth - 1
        
        date = formatter.date(from: "\(newYear) \(newMonth) 1") ?? .init()
    }
    
    func backwardMonth() {
        let newYear: Int = currentMonth == 12 ? currentYear + 1 : currentYear
        let newMonth: Int = currentMonth == 12 ? 1 : currentMonth + 1
        
        date = formatter.date(from: "\(newYear) \(newMonth) 1") ?? .init()
    }
    
    func convertStringToDate(_ date: String) -> Date {
        formatter.date(from: date) ?? .init()
    }
    
    func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd(EEEEE)"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: date)
   }
}
