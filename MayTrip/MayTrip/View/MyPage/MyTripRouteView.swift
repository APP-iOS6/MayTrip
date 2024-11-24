//
//  MyTripRouteView.swift
//  MayTrip
//
//  Created by 이소영 on 11/24/24.
//
import SwiftUI

struct MyTripRouteView: View {
    @Environment(\.dismiss) var dismiss
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
                    ForEach(tripRouteStore.myTripRoutes) { route in
                        RecommendContentView(route: route, isSharing: false)
                    }
                }
                .padding()
            }
            .padding(.vertical, 1)
            
            if tripRouteStore.myTripRoutes.count == 0 {
                Text("나의 여행이 비어있습니다")
            }
        }
        .onAppear {
            Task {
                try await tripRouteStore.getTripRouteList()
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                .foregroundStyle(.black)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("나의 여행")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}
