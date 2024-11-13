//
//  RecommendRouteView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct RecommendRouteView: View {
    @StateObject var tripRouteStore: TripRouteStore = TripRouteStore()
    
    let dateStore: DateStore = .shared
    
    var season: String {
        dateStore.convertMonthToSeason(Date())
    }
    
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
                        ForEach(0..<5) { index in
                            if index < categorizedRoute(standard).count {
                                RecommendContentView(route: categorizedRoute(standard)[index])
                                    .padding(2)
                            }
                        }
                    }
                    .padding(.trailing)
                }
            }
            .padding([.leading, .vertical])
        }
        .onAppear {
            Task {
                try await tripRouteStore.getTripRouteList()
            }
        }
    }
    
    private func categorizedRoute(_ standard: Standard) -> [TripRouteSimple] {
        return switch standard {
        case .bestSeason:
            tripRouteStore.list.filter {
                // TODO: 찜을 가장 많이 받은 여행 중에서 계절별로 필터링 하는 로직 추가하기
                dateStore.convertMonthToSeason(dateStore.convertStringToDate($0.start_date)) == season
            }
        case .savedAlot:
            // TODO: 찜을 가장 많이 받은 여행 필터링하는 로직 추가하기
            tripRouteStore.list
        }
    }
}

enum Standard: String, CaseIterable {
    case savedAlot = "찜을 가장 많이 받은 여행"
    case bestSeason = "지금 계절에 가기 좋은 여행"
}

#Preview {
    RecommendRouteView()
}
