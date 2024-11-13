//
//  DateStore.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI
import Observation

@Observable
final class DateStore {
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
            
            if let _ = endDate {
                self.startDate = date
                self.endDate = nil
            } else {
                if startDate > date {
                    self.startDate = date
                } else {
                    endDate = date
                }
            }
        } else {
            startDate = date
        }
    }
    
    func setTripDates(from startDate: Date, to endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func initDate() {
        self.startDate = nil
        self.endDate = nil
    }
    
    // 다음달로 달력 넘김
    func forwardMonth() {
        let newYear: Int = currentMonth == 1 ? currentYear - 1 : currentYear
        let newMonth: Int = currentMonth == 1 ? 12 : currentMonth - 1
        
        date = formatter.date(from: "\(newYear) \(newMonth) 1") ?? .init()
    }
    
    // 이전달로 달력 넘김
    func backwardMonth() {
        let newYear: Int = currentMonth == 12 ? currentYear + 1 : currentYear
        let newMonth: Int = currentMonth == 12 ? 1 : currentMonth + 1
        
        date = formatter.date(from: "\(newYear) \(newMonth) 1") ?? .init()
    }

    // 스트링 날짜를 데이트로 반환
    func convertStringToDate(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) ?? .init()
    }
    
    // 데이트를 스트링 날짜로 반환
    func convertDateToString(_ date: Date, format: String = "yyyy MM d") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.string(from: date)
    }
    
    // 여행기간에 따라 여행일정을 스트링으로 반환 (당일치기, n박 n+1일, 장기) 여행
    func convertPeriodToString(_ start: String, end: String) -> String {
        let start = convertStringToDate(start)
        let end = convertStringToDate(end)
        
        let dateDiff = Calendar.current.dateComponents([.year, .month, .day], from: start, to: end)
        
        var dateString = "당일치기"
        
        if case let (year?, month?, day?) = (dateDiff.year, dateDiff.month, dateDiff.day) {
            if day != 0 {
                dateString = "\(day)박 \(day + 1)일"
            }
            
            if year != 0 || month != 0 {
                dateString = "장기"
            }
        }
        
        return dateString
    }
    
    // 시작 날짜 부터 끝날짜 범위의 날짜 배열을 반환하는 함수
    func datesInRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let lastDate = endDate
        
        while currentDate <= lastDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    func datesInRange() -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate ?? .now
        let lastDate = endDate ?? .now
        
        while currentDate <= lastDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    // 현재 여행중인지를 반환
    func isOnATrip(_ start: String, end: String) -> Bool {
        let start = convertStringToDate(start)
        let end = convertStringToDate(end)
        
        let date = Date()
        
        let today = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let startDay = Calendar.current.dateComponents([.year, .month, .day], from: start)
        let endDay = Calendar.current.dateComponents([.year, .month, .day], from: end)
        
        return today == startDay || today == endDay || (date > start && date < end)
    }
    
    // 날짜별 계절을 스트링으로 반환
    func convertMonthToSeason(_ start: Date) -> String {
        let month = Calendar.current.component(.month, from: start)
        var season: String = ""
        
        switch month {
        case 1, 2, 3, 12: season = "겨울"
        case 4, 5, 6: season = "봄"
        case 7, 8, 9: season = "여름"
        case 10, 11: season = "가을"
        default: break
        }
        
        return season
    }
}
