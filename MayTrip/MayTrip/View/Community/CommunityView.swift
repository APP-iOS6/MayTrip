//
//  CommunityView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

enum postCategory : String, CaseIterable {
    case all = "전체", question = "질문", findCompanion = "동행찾기", tripReview = "여행후기", recommandRestaurant = "맛집추천"
}

enum orderCategory : String, CaseIterable {
    case new = "최신순", store = "저장순", reply = "댓글순"
}

struct CommunityView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @State var selectedPostCategory: postCategory = .all
    @State var selectedOrderCategory: orderCategory = .new
    @State var isShowingOrderCategory: Bool = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack(spacing: proxy.size.height * 0.015) {
                    CommunityHeaderView(isShowingOrderCategory: $isShowingOrderCategory, selectedPostCategory: $selectedPostCategory, selectedOrderCategory: $selectedOrderCategory, width: screenWidth, height: screenHeight)
                    
                    CommunityBodyView(isShowingOrderCategory: $isShowingOrderCategory, selectedOrderCategory: $selectedOrderCategory, width: screenWidth, height: screenHeight)
                }
                .onTapGesture {
                    isShowingOrderCategory = false
                }
                .toolbar {
                    HStack(spacing: 20) {
                        Spacer()
                        
                        Button { // 검색 버튼 로직 추가하기
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .frame(width: 15, height:  15)
                                .foregroundStyle(Color.accent)
                        }
                        
                        NavigationLink { // 게시글 작성
                            CommunityPostAddView()
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 15, height:  15)
                                .foregroundStyle(Color.accent)
                                .padding(.trailing, screenWidth * 0.01)
                        }
                    }
                    
                }
            }
            
        }
        .onAppear {
            Task {
                try await communityStore.updatePost()
            }
        }
    }
}



#Preview {
    CommunityView()
}

