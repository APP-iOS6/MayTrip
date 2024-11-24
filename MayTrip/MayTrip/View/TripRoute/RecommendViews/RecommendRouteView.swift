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
    
    var background: Color = Color(uiColor: .systemGray6)
    var scrollProxy: ScrollViewProxy
    
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
                        tripRouteStore.orderTypeChange(type: .createdAt)
                        scrollProxy.scrollTo(0, anchor: .top)
                    } label: {
                        Text("최신순")
                            .font(.callout)
                            .foregroundStyle(tripRouteStore.orderType == .createdAt ? Color("accentColor") : .gray)
                    }.disabled(tripRouteStore.orderType == .createdAt)
                    
                    Divider()
                    
                    Button {
                        tripRouteStore.orderTypeChange(type: .count)
                        scrollProxy.scrollTo(0, anchor: .top)
                    } label: {
                        Text("보관많은순")
                            .font(.callout)
                            .foregroundStyle(tripRouteStore.orderType == .count ? Color("accentColor") : .gray)
                    }.disabled(tripRouteStore.orderType == .count)
                }
            }
                .background(background)
            ) {
                ForEach(tripRouteStore.list) { route in
                    RecommendContentView(route: route)
                }
            }
            
        }
        
        //.padding(.horizontal)
    }
}

#Preview {
    ScrollViewReader { proxy in
        RecommendRouteView(scrollProxy: proxy)
    }
    
}
