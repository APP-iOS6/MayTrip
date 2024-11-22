//
//  PlaceAddHeaderView.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import SwiftUI

struct PlaceHeaderView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var cities: [String]
    var places: [[PlacePost]]
    var title: String
    var tags: [String]
    var tripRoute: TripRoute?
    
    var body: some View {
        // 도시 태그 뷰
        VStack {
            CityTagFlowLayout(spacing: 10) {
                ForEach(cities, id: \.self) { city in
                    Text("# \(city)")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundStyle(Color(UIColor.darkGray))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}
