//
//  PostCommentView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct CommentView: View {
    @State var isPresented: Bool = false
    
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
                        Text("닉네임")
                            .font(.system(size: 14))
                            .bold()
                        
                        // 댓글 시간
                        Text("00분 전")
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
                Text("저도 저번주에 여기 갔다왔었는데, 사진보다 훨씬 퀄리티도 괜찮고, 가격도 착해서 주변 사람들한테 추천하고있어요!")
            }
        }
        .sheet(isPresented: $isPresented) {
            PostMenuSheetView(
                isPresented: $isPresented,
                selectedCommentOwner: -1,
                selectedCommentId: -1
            )
            .presentationDetents([.height(170)])
            .presentationDragIndicator(.visible)
        }
    }
}
