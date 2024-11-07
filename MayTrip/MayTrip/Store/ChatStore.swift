//
//  ChatStore.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI
import Observation

@Observable
class ChatStore {
    static let shared: ChatStore = ChatStore()
    
    init() {
        
    }
    
    // 날짜를 입력 받아서 현재 시간으로부터 얼마나 차이가 나는지 계산
    func timeDifference(_ date: Date) -> String {
        let current = Calendar.current
        
        let dateDiff = current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        
        let dateString = formatter.string(from: date)
        
        if case let (year?, month?, day?, hour?, minute?) = (dateDiff.year, dateDiff.month, dateDiff.day, dateDiff.hour, dateDiff.minute) {
            
            if year == 0 || month == 0 || day == 0 {
                if hour != 0 {
                    return "\(hour)시간 전"
                }
                if minute != 0 {
                    return "\(minute)분 전"
                }
                return "방금 전"
            }
        }
        return dateString
    }

}
