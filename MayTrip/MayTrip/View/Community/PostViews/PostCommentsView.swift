//
//  PostCommentsView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostCommentsView: View {
    @Environment(CommunityStore.self) var communityStore
    @State var inputComment: String = ""
    var postId: Int
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Text("댓글 \(communityStore.comments[postId] != nil ? communityStore.comments[postId]!.count : 0)")
                
                Spacer()
                
                Button {
                    Task {
                        await communityStore.getPostCommentList(postId: postId)
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.gray)
                }
            }
            
            ForEach(communityStore.comments[postId] ?? [], id: \.self) { comment in
                CommentView(comment: comment, width: width, height: height)
            }
        }
        .padding([.horizontal, .top])
        
        
    }
}
