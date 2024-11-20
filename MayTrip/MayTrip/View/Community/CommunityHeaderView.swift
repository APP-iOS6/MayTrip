//
//  CommunityHeaderView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityHeaderView: View {
    @Binding var selectedPostCategory: postCategory
    @Binding var selectedOrderCategory: orderCategory
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 10) {
                ForEach(postCategory.allCases, id:\.self) { tag in
                    Button {
                        selectedPostCategory = tag
                    } label: {
                        Text(tag.rawValue)
                            .bold()
                            .font(.system(size: width * 0.042))
                            .foregroundStyle($selectedPostCategory.wrappedValue == tag ? .black : .gray)
                            .padding(.horizontal, width * 0.02)
                            .padding(.vertical, height * 0.007)
                            .background {
                                if $selectedPostCategory.wrappedValue == tag {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color(uiColor: .systemGray6))
                                }
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 10)
            .padding(.bottom, height * 0.01)
        }
        .background(Color(uiColor: .systemBackground))
        
        HStack(spacing: 10) { // 정렬 필터
            Spacer()
            Button {
                selectedOrderCategory = .new
            } label: {
                Text("최신순")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .disabled(selectedOrderCategory == .new)
            .foregroundStyle(selectedOrderCategory == .new ? Color.accent : Color.gray)
            
            Divider()
            
            Button {
                selectedOrderCategory = .reply
            } label: {
                Text("댓글순")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .disabled(selectedOrderCategory == .reply)
            .foregroundStyle(selectedOrderCategory == .reply ? Color.accent : Color.gray)
        }
        .bold()
        .frame(height: height * 0.03)
        .padding(.horizontal, width * 0.06)
    }
}

#Preview {
    CommunityView()
        .environment(CommunityStore())
}
