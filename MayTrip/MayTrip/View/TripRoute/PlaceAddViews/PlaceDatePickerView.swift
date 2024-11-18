//
//  PlaceAddDatePickerView.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import SwiftUI

struct PlaceDatePickerView: View {
    @Binding var focusedDayIndex: Int
    @Binding var isShowDatePicker: Bool

    var scrollingIndex: Int
    
    let dateStore: DateStore = DateStore.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("날짜 선택")
                .font(.title2)
                .padding([.top, .horizontal], 32)
            
            ScrollView {
                ForEach(Array(dateStore.datesInRange().enumerated()), id: \.element) { index, date in
                    Button {
                        focusedDayIndex = index
                        isShowDatePicker = false
                    } label: {
                        HStack {
                            Text("Day\(index+1) \(dateStore.convertDateToString(date, format:  "MM.dd(E)"))")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray)
                                )
                                .padding(.horizontal)
                        }
                        .foregroundStyle(Color.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                }
            }
            .padding([.horizontal, .bottom])
            .presentationDetents([.medium])
        }
        .onAppear {
            focusedDayIndex = scrollingIndex
        }
    }
}
