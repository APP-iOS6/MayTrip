//
//  SearchRootView.swift
//  MayTrip
//
//  Created by 이소영 on 11/20/24.
//
import SwiftUI

struct CommunitySearchResultView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    
    var body: some View {
        if communityStore.filteredPosts.isEmpty {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("검색 결과가 없습니다")
                    Spacer()
                }
                Spacer()
            }
        } else {
            ScrollView {
                CommunityPostListView(posts: communityStore.filteredPosts, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
        }
    }
}
