//
//  PostCommentsView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostCommentsView: View {
    @Environment(CommunityStore.self) var communityStore
    @Binding var comments: [PostComment]
    @State var inputComment: String = ""
    var postId: Int
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("댓글 \(comments.count)")
                
                Spacer()
                
                Button {
                    Task {
                        await comments = communityStore.getPostCommentList(postId: postId) ?? []
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.gray)
                }
            }
            
            ForEach(comments, id: \.self) { comment in
                CommentView(comment: comment, width: width, height: height)
            }
        }
        .padding([.horizontal, .top])
        
        
    }
}
