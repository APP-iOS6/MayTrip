//
//  PostDetailView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
//    @State var comments: [PostComment]
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var isImageExist: Bool {
        !communityStore.selectedPost.image.isEmpty
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    if isImageExist {
                        // 상단 이미지 뷰
                        PostImageView(post: communityStore.selectedPost)
                            .frame(height: screenHeight * 0.3)
                    }
                    
                    // 중앙 게시글 정보 뷰
                    PostTitleView(post: communityStore.selectedPost, width: screenWidth, height: screenHeight)
                        .padding([.top, .horizontal])
                    
                    // 하단 게시글 내용 뷰
                    PostContentView(post: communityStore.selectedPost)
                        .padding([.bottom, .horizontal])
                    
                    Rectangle()
                        .fill(Color(uiColor: .systemGray6))
                        .frame(width: screenWidth, height: screenHeight * 0.015)
                    
                    // 하단 댓글 뷰
                    PostCommentsView(/*comments: communityStore.comments, */postId: communityStore.selectedPost.id, width: screenWidth, height: screenHeight)
                    
                    Color.clear.frame(height: 1)
                        .id("comment")
                }
                .scrollIndicators(.hidden)
                .onChange(of: communityStore.comments[communityStore.selectedPost.id]!.count) {
                    withAnimation {
                        proxy.scrollTo("comment", anchor: .bottom)
                    }
                }
            }
            
            CommentSendView(postId: communityStore.selectedPost.id)
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

