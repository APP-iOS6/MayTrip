//
//  RecommendRouteView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct RecommendRouteView: View {
    var routeStore: DummyRouteStore = .shared
    
    var body: some View {
        ForEach(Standard.allCases, id: \.self) { standard in
            VStack {
                NavigationLink {
                    // TODO: 루트 리스트 뷰 이동
                } label: {
                    HStack(alignment: .center) {
                        Text("\(standard.rawValue)")
                            .font(.title3)
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Text("더보기")
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("accentColor"))
                }
                .padding(.trailing)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(routeStore.categorizeRoute(standard)) { route in
                            RecommendContentView(route: route)
                                .padding(2)
                        }
                    }
                    .padding(.trailing)
                }
            }
            .padding([.leading, .vertical])
        }
    }
}



#Preview {
    RecommendRouteView()
}
