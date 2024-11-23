//
//  PostTitleView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostTitleView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @State var isPresented: Bool = false
    @State var selectedPostOwner: Int = 0
    @State var selectedPostId: Int = 0
    
    var post: PostUserVer
    var width: CGFloat
    var height: CGFloat
    
    let tags: [String] = ["만족도 100%", "도쿄", "아샤쿠사", "힐링", "취미활동", "도쿄", "아샤쿠사", "힐링", "취미활동"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 프로필
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.07)
                    .foregroundStyle(Color.accent)
                    .padding(7)
                    .overlay {
                        Circle()
                            .foregroundStyle(Color.accent.opacity(0.5))
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        // 카테고리
                        Text(communityStore.getCategoryName(categoryNumber: post.category))
                            .font(.system(size: 12))
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.primary)
                            }
                        
                        Spacer()
                        Button {
                            isPresented = true
                            selectedPostOwner = post.author.id
                            selectedPostId = post.id
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.gray)
                        }
                    }
                    // 닉네임
                    Text(post.author.nickname)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
            }
            
            // 타이틀
            Text(post.title)
                .font(.system(size: 26))
                .bold()
            
            // 태그
            if let tags = post.tag {
                HStack(spacing: 5) {
                    CityTagFlowLayout {
                        ForEach(tags, id: \.self) { tag in
                            Text("\(tag)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(uiColor: .orange))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.orange.opacity(0.15))
                                }
                        }
                    }
                }
            }
            
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $isPresented) {
            CommunityMenuSheetView(
                isPresented: $isPresented,
                selectedPostOwner: $selectedPostOwner,
                selectedPostId: $selectedPostId
            )
            .presentationDetents([.height(170)])
            .presentationDragIndicator(.visible)
        }
    }
}
