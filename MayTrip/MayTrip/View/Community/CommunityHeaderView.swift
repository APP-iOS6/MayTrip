//
//  CommunityHeaderView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityHeaderView: View {
    @Binding var isShowingOrderCategory: Bool
    @Binding var selectedPostCategory: postCategory
    @Binding var selectedOrderCategory: orderCategory
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                ForEach(postCategory.allCases, id:\.self) { tag in
                    Button {
                        selectedPostCategory = tag
                    } label: {
                        Text(tag.rawValue)
                            .font(.system(size: width * 0.0407))
                            .foregroundStyle($selectedPostCategory.wrappedValue == tag ? .white : .gray)
                            .padding(10)
                            .background {
                                if $selectedPostCategory.wrappedValue == tag {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray)
                                }
                            }
                    }
                }
            }
            .frame(width: width * 0.96, alignment: .center)
            .padding(.horizontal, width * 0.02)
            .padding(.top, height * 0.005)
            
            HStack { // 정렬 필터
                Spacer()
                
                Button {
                    isShowingOrderCategory.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Text("\($selectedOrderCategory.wrappedValue.rawValue)")
                            .font(.system(size:width * 0.039))
                            .foregroundStyle(.black)
                        Image(systemName: isShowingOrderCategory ? "chevron.up" :"chevron.down")
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                    }
                }
            }
            .padding(.horizontal, width * 0.05)
        }
    }
}
