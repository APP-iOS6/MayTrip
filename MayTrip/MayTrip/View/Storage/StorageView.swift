//
//  StorageView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct StorageView: View {
    @EnvironmentObject var tripRouteStore: TripRouteStore
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVGrid(columns: gridItems, alignment: .leading, spacing: 10) {
                    ForEach(tripRouteStore.list) { route in // TODO: 보관함에 있는 루트들로 변경
                        RecommendContentView(route: route)
                    }
                }
                .padding()
            }
            .padding(.vertical, 1)
            //            if // TODO: 보관된 루트 없을때에 만 보이도록
            //            Text("보관함이 비어있습니다")
            //                .foregroundStyle(.gray)
        }
        .onAppear {
            Task {
                try await tripRouteStore.getTripRouteList()
            }
        }
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
    }
}
