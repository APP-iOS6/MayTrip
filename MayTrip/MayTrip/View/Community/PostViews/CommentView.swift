//
//  PostCommentView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct CommentView: View {
    @State var isPresented: Bool = false
    @State var comment: PostComment
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            // 프로필
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.accent)
                    .frame(width: width * 0.07)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        // 닉네임
                        Text(comment.writeUser.nickname)
                            .font(.system(size: 14))
                            .bold()
                        
                        // 댓글 시간
                        Text("\(DateStore().timeAgo(from: comment.createdAt))")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    
                    // 메뉴 버튼
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                    }
                }
                
                // 댓글 내용
                Text(comment.comment)
            }
        }
        .sheet(isPresented: $isPresented) {
            PostMenuSheetView(
                isPresented: $isPresented,
                selectedCommentOwner: comment.writeUser.id,
                selectedCommentId: comment.id
            )
            .presentationDetents([.height(170)])
            .presentationDragIndicator(.visible)
        }
    }
}
