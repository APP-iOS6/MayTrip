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
                .font(.title)
                .bold()
                .padding([.top, .horizontal])
            
            ScrollView {
                ForEach(Array(dateStore.datesInRange().enumerated()), id: \.element) { index, date in
                    Button {
                        focusedDayIndex = index
                        isShowDatePicker = false
                    } label: {
                        HStack {
                            Text("Day \(index+1)")
                                .font(.headline)
                                .bold()
                            
                            Spacer()
                            
                            Text(dateStore.convertDateToString(date, format: "yyyy년 MM월 dd일(E)"))
                        }
                        .padding()
                        .foregroundStyle(getColor(index: index))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(getColor(index: index))
                                .opacity(0.1)
                        }
                    }
                    .padding(.bottom, 7)
                }
            }
            .padding([.horizontal, .bottom])
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .padding(.top)
        .onAppear {
            focusedDayIndex = scrollingIndex
        }
    }
    
    private func getColor(index: Int) -> Color {
        index == focusedDayIndex ? Color("accentColor") : Color(uiColor: .systemGray)
    }
}
