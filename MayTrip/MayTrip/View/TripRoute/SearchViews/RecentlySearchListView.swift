//
//  RecentlySearchListView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI

struct RecentlySearchListView: View {
    var body: some View {
        Text("최근 검색어")
            .padding(.top, 25)
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<8) { index in
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 17)
                            .stroke(.gray, lineWidth: 1)
                            .overlay {
                                HStack {
                                    Text("검색 \(index + 1)")
                                        .lineLimit(1)
                                        .padding(8)
                                    Image(systemName: "xmark")
                                }
                                .foregroundStyle(.gray)
                            }
                    }
                    .frame(width: 100, height: 35)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}