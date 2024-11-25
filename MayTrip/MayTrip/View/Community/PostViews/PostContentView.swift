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
            if let tripRoute = post.tripRoute {
                Button {
                    navigationManager.selection = 0
                } label: {
                    RecommendContentView(route: tripRoute)
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
