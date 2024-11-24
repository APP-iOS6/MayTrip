//
//  RecommendRouteView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct RecommendRouteView: View {
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @State var isRecently: Bool = true
    
    var background: Color
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
            Section(header:
                        VStack(alignment: .leading) {
                HStack {
                    Text("여행 둘러보기")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        // TODO: 리스트 최신순으로 변경
                        isRecently = true
                    } label: {
                        Text("최신순")
                            .font(.callout)
                            .foregroundStyle(isRecently ? Color("accentColor") : .gray)
                    }
                    
                    Divider()
                    
                    Button {
                        // TODO: 리스트 보관많은순으로 변경
                        isRecently = false
                    } label: {
                        Text("보관많은순")
                            .font(.callout)
                            .foregroundStyle(!isRecently ? Color("accentColor") : .gray)
                    }
                }
            }
                .background(background)
            ) {
                ForEach(tripRouteStore.list) { route in
                    RecommendContentView(route: route)
                }
            }
            .onAppear {
                Task {
                    try await tripRouteStore.getTripRouteList()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RecommendRouteView(background: .gray)
}
