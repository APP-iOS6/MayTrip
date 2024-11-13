//
//  YearAndMonthView.swift
//  MayTrip
//
//  Created by 이소영 on 11/2/24.
//


import SwiftUI

struct YearAndMonthView: View {
    var dateStore: DateStore = DateStore.shared
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack {
            Button {
                dateStore.forwardMonth()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
            }
            
            Text("\(String(dateStore.currentYear))년 \(dateStore.currentMonth)월")
                .font(.system(size: 18))
            
            Button {
                dateStore.backwardMonth()
            } label: {
                HStack {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
            }
            
            Spacer()
            
            
            Button {
                isShowing = false
            } label: {
                Text("닫기")
                    .padding(10)
                    .font(.system(size: 15))
            }
            .foregroundStyle(.gray)
        }
        .foregroundStyle(.black)
        .padding(.vertical, 5)
        .frame(maxWidth: 280)
    }
}

//#Preview {
//    YearAndMonthView()
//}
