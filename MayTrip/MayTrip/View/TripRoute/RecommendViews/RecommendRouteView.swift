//
//  RecommendRouteView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct RecommendRouteView: View {
    var body: some View {
        VStack {
            NavigationLink {
                // TODO: 루트 리스트 뷰 이동
            } label: {
                HStack {
                    Text("찜을 가장 많이 받은 루트")
                        .font(.title3)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.vertical, 8)
            .foregroundStyle(.black)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<4) { index in
                        RecommendContentView()
                    }
                }
            }
        }
        .padding()
    }
}



#Preview {
    RecommendRouteView()
}
