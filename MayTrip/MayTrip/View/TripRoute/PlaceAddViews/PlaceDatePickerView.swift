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
                .font(.headline)
                .padding([.top, .horizontal], 36)
            
            List {
                ForEach(Array(dateStore.datesInRange().enumerated()), id: \.element) { index, date in
                    Button {
                        focusedDayIndex = index
                        isShowDatePicker = false
                    } label: {
                        HStack {
                            Text("Day\(index+1) \(dateStore.convertDateToString(date, format:  "MM.dd(E)"))")
                                .foregroundStyle(.primary)
                            if index == focusedDayIndex {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                        .foregroundStyle(index == focusedDayIndex ? .accent : Color.primary)
                        .padding(.horizontal)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .presentationDetents([.medium])
        }
        .onAppear {
            focusedDayIndex = scrollingIndex
        }
    }
}
