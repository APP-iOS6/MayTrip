//
//  PostDetailView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var comments: [PostComment]
    
    var post: PostUserVer
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var isImageExist: Bool {
        !post.image.isEmpty
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
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
                        .frame(width: screenWidth, height: screenHeight * 0.015)
                    
                    // 하단 댓글 뷰
                    PostCommentsView(comments: $comments, postId: post.id, width: screenWidth, height: screenHeight)
                        
                    Color.clear.frame(height: 1)
                        .id("comment")
                }
                .scrollIndicators(.hidden)
                .onChange(of: comments.count) {
                    withAnimation {
                        proxy.scrollTo("comment", anchor: .bottom)
                    }
                }
            }
            
            CommentSendView(comments: $comments, postId: post.id)
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

struct CommentSendView: View {
    @Environment(CommunityStore.self) var communityStore
    @Binding var comments: [PostComment]
    @State var inputComment: String = ""
    var postId: Int
    
    var body: some View {
        HStack {
            TextField("댓글을 입력해주세요", text: $inputComment, axis: .vertical)
            
            Button {
                Task {
                    await addComment()
                }
            } label: {
                Image(systemName: "paperplane")
                    .foregroundStyle(inputComment == "" ? .gray : Color("accentColor"))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 18)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 1)
        )
        .padding([.horizontal, .bottom])
    }
    
    @MainActor
        func addComment() async {
            let text = inputComment.trimmingCharacters(in: .whitespacesAndNewlines)
            let comment = InsertPostComment(userId: UserStore.shared.user.id, postId: postId, comment: text)
            await communityStore.insertPostComment(comment: comment)
            inputComment = ""
            self.comments = await communityStore.getPostCommentList(postId: postId) ?? []
        }
}

#Preview {
    NavigationStack {
        CommunityView()
    }
        .environment(CommunityStore())
}

