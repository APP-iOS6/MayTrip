//
//  PlaceInfoView.swift
//  MayTrip
//
//  Created by 최승호 on 11/3/24.
//

import SwiftUI

struct PlaceInfoView: View {
    let dateStore: DateStore = DateStore()
    var dateIndex: Int
    var date: Date
    var isEditing: Bool
    @Binding var places: [[PlacePost]]      // 추가된 장소 (배열당 한 일차 장소배열)
    @Binding var isShowSheet: Bool      // 장소 추가시트 띄우기
    @Binding var isShowDatePicker: Bool
    @Binding var selectedDay: Int       // 장소 추가시에 몇일차에 장소 추가하는지

    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading) {
            // 상단 날짜 정보
            Button {
                isShowDatePicker.toggle()
            } label: {
                HStack {
                    Text("DAY\(dateIndex + 1)")
                        .foregroundStyle(Color.primary)
                        .bold()
                    Text(dateStore.convertDateToString(date, format:  "MM.dd(E)"))
                        .foregroundStyle(.gray)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 14))
                .padding([.horizontal, .top])
            }
            
            // 중앙 장소 정보
            if places.count > 0 && dateIndex < places.count {
                List {
                    ForEach(Array(places[dateIndex].enumerated()), id: \.element.coordinates) { placeIndex, place in
                        HStack {
                            // 좌측 번호 영역
                            VStack(spacing: 0) {
                                if placeIndex != 0 {
                                    Line()
                                        .stroke(Color(uiColor: .systemGray4))
                                        .frame(width: 1)
                                } else {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: 1)
                                }
                                
                                Image(systemName: "\(placeIndex + 1).circle.fill")
                                
                                if placeIndex != places[dateIndex].count - 1 , places[dateIndex].count > 1 {
                                    Line()
                                        .stroke(Color(uiColor: .systemGray4))
                                        .frame(width: 1)
                                } else {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: 1)
                                }
                            }
                            
                            // 우측 장소 카드 영역
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(place.name)")
                                    .font(.system(size: 16))
                                    .bold()
                                Text(PlaceStore.getCategory(place.categoryCode))
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                            }
                            .padding(.leading)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(.horizontal)
                        .frame(width: width, height: height * 0.1)
                    }
                    .onDelete { indexSet in
                        places[dateIndex].remove(atOffsets: indexSet)   // 리스트 내 장소정보 삭제
                    }
                    .onMove { (source: IndexSet, destination: Int) -> Void in
                        self.places[dateIndex].move(fromOffsets: source, toOffset: destination)
                    }
                    .deleteDisabled(!isEditing)
                    .moveDisabled(!isEditing)
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                .frame(height: CGFloat(places[dateIndex].count) * height * 0.1)   // scrollview 내에 list를 넣게되어 리스트뷰 높이를 지정
            }
            
            // 하단 '장소추가' 버튼
            if isEditing {
                Button {
                    isShowSheet.toggle()
                    self.selectedDay = dateIndex
                } label: {
                    Text("장소 추가")
                        .foregroundStyle(Color.primary)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding([.horizontal, .bottom])
            }
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
