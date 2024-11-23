//
//  PostDetailView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @Environment(\.dismiss) var dismiss
    var post: PostUserVer
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var isImageExist: Bool {
        !post.image.isEmpty
    }
    
    var body: some View {
        ScrollView {
            if isImageExist {
                // 상단 이미지 뷰
                PostImageView(post: post)
                    .frame(height: screenHeight * 0.3)
            }
            
            // 중앙 게시글 정보 뷰
            PostTitleView(post: post, width: screenWidth, height: screenHeight)
                .padding([.top, .horizontal])
            
            // 하단 게시글 내용 뷰
            PostContentView(post: post)
                .padding([.bottom, .horizontal])
            
            Rectangle()
                .fill(Color(uiColor: .systemGray6))
                .frame(width: screenWidth, height: screenHeight * 0.03)
            
            // 하단 댓글 뷰
            PostCommentsView(width: screenWidth, height: screenHeight)
                .padding(.top)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunityView()
    }
        .environment(CommunityStore())
}

