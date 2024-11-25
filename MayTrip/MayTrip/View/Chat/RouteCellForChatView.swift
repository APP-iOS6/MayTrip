//
//  RouteCellForChatView.swift
//  MayTrip
//
//  Created by 이소영 on 11/22/24.
//


import SwiftUI

struct RouteCellForChatView: View {
    @Binding var selectedRouted: Int?
    var route: TripRouteSimple
    
    private let dateStore: DateStore = .shared
    
    var body: some View {
        Button {
            selectedRouted = selectedRouted == route.id ? nil : route.id
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(route.city[0])
                        .font(.footnote)
                        .foregroundStyle(Color("accentColor"))
                        .padding(.horizontal, 13)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .foregroundStyle(Color("accentColor").opacity(0.2))
                        }
                    
                    Spacer()
                }
                Text(route.title)
                    .font(.title3)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.top, 8)
                    .multilineTextAlignment(.leading)
                
                Text("\(dateStore.convertPeriodToString(route.startDate, end: route.endDate)) 일정")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.top, 5)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 15)
            .padding(.trailing, 5)
            .frame(width: UIScreen.main.bounds.width / 3 * 2, height: UIScreen.main.bounds.height / 6.2)
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(selectedRouted == route.id ? Color("accentColor") : Color(uiColor: .systemGray5), lineWidth: 1)
        }
    }
}
