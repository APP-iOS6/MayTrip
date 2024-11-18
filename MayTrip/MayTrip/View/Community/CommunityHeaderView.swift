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
         
                Picker("",selection: $selectedOrderCategory) {
                    ForEach(orderCategory.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .accentColor(.black)
                .foregroundStyle(.black)
            }
            .padding(.horizontal, width * 0.02)
        }
    }
}
