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
    @State var selectedPostCategory: postCategory = .all
    @State var selectedOrderCategory: orderCategory = .new
    @State var isShowingOrderCategory: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: proxy.size.height * 0.03) {
                CommunityHeaderView(selectedPostCategory: $selectedPostCategory, width: proxy.size.width, height: proxy.size.height)
                
                CommunityBodyView(isShowingOrderCategory: $isShowingOrderCategory, selectedOrderCategory: $selectedOrderCategory, width: proxy.size.width, height: proxy.size.height)
            }
            .onTapGesture {
                isShowingOrderCategory = false
            }
        }
    }
}



#Preview {
    CommunityView()
}

