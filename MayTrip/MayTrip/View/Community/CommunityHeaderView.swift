//
//  CommunityHeaderView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityHeaderView: View {
    @Binding var selectedPostCategory: postCategory
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing : height * 0.025) { // 헤더 (감색, 필터)
            HStack(spacing: 12) {
                Spacer()
                
                Button { // 검색 버튼 로직 추가하기
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundStyle(.black)
                }
                
                NavigationLink { // 게시글 작성
                    CommunityPostAddView()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundStyle(.black)
                }
            }
            
            HStack {
                ForEach(postCategory.allCases, id:\.self) { tag in
                    Button {
                        selectedPostCategory = tag
                    } label: {
                        Text(tag.rawValue)
                            .font(.system(size: width * 0.04))
                            .foregroundStyle($selectedPostCategory.wrappedValue == tag ? .white : .gray)
                            .padding(10)
                            .background {
                                if $selectedPostCategory.wrappedValue == tag {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle( Color.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray)
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, width * 0.05)
    }
}
