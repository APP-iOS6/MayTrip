//
//  PostContentView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var tripRouteStore: TripRouteStore
    
    var post: PostUserVer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 게시글 내용
            Text(post.text)
                .font(.system(size: 16))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            
            // 여행루트 카드
            if let tripRouteID = post.tripRoute {
                Button {
                    navigationManager.selection = 0
                } label: {
                    RecommendContentView(route: tripRouteStore.list.filter{ $0.id == tripRouteID }.first ?? sampleRoute)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent)
                        }
                }
            }
        }
        .padding(.bottom)
    }
}

let sampleRoute: TripRouteSimple = .init(
    id: -1,
    title: "오늘은 여기어때?",
    tag: ["최애여행", "인생여행", "힐링"],
    city: ["서울"],
    writeUser: .init(id: -1, nickname: "김철수", profileImage: nil),
    start_date: "2024-11-29",
    end_date: "2024-11-29"
)
