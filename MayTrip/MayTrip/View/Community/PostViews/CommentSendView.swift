//
//  CommentSendView.swift
//  MayTrip
//
//  Created by 강승우 on 11/25/24.
//

import SwiftUI

struct CommentSendView: View {
    @Environment(CommunityStore.self) var communityStore
//    @Binding var comments: [PostComment]
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
        let comment = InsertPostComment(userId: UserStore.shared.user.id, postId: communityStore.selectedPost.id, comment: text)
        await communityStore.insertPostComment(comment: comment)
        inputComment = ""
        await communityStore.getPostCommentList(postId: communityStore.selectedPost.id)
    }
}
