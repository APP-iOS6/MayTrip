//
//  CommunityBodyView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityBodyView: View {
    @Binding var isShowingOrderCategory: Bool
    @Binding var selectedOrderCategory: orderCategory
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                
                Button {
                    isShowingOrderCategory.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Text("\($selectedOrderCategory.wrappedValue.rawValue)")
                            .font(.system(size:16))
                            .foregroundStyle(.black)
                        Image(systemName: isShowingOrderCategory ? "chevron.up" :"chevron.down")
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                    }
                }
                .overlay(alignment: .top) {
                    if isShowingOrderCategory {
                        orderCategoryListView(width: width, height: height)
                            .offset(x: -20, y : 30)
                    }
                }
            }
            .padding(.horizontal, width * 0.06)
        }
    }
}

extension CommunityBodyView {
    @ViewBuilder
    func orderCategoryListView(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 0.1)
                .frame(width : width * 0.22, height: height * 0.15)
            VStack(spacing: 15) {
                ForEach(orderCategory.allCases, id:\.self) { category in
                    Button {
                        self.selectedOrderCategory = category
                        self.isShowingOrderCategory = false
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size:16))
                            .foregroundStyle(self.selectedOrderCategory == category ? .black : Color(uiColor: .systemGray3))
                            .padding(.horizontal,5)
                    }
                }
            }
        }
    }
}
