//
//  YearAndMonthView.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI

struct YearAndMonthView: View {
    var dateStore: DateStore = DateStore.shared
    
    var body: some View {
        HStack {
            // TODO: 버튼 눌리는 부분 늘리기
            Button {
                dateStore.forwardMonth()
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Text("\(String(dateStore.currentYear))년 \(dateStore.currentMonth)월")
                .font(.system(size: 18))
            
            Button {
                dateStore.backwardMonth()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.black)
        .padding(.vertical)
    }
}
