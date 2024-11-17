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
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            ScrollView {
                CommunityPostListView(width: width, height: height)
            }
            .refreshable {
                Task {
                    try await communityStore.updatePost()
                }
            }
            if isShowingOrderCategory {
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        orderCategoryListView(width: width, height: height)
                            .padding(.horizontal, width * 0.05)
                    }
                    Spacer()
                }
            }
        }
    }
}

extension CommunityBodyView {
    @ViewBuilder
    func orderCategoryListView(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width : width * 0.22, height: height * 0.15)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 0.1)
                }
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
                            .background(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    CommunityBodyView(isShowingOrderCategory: .constant(false), selectedOrderCategory: .constant(.new), width: UIScreen.main.bounds.width
                      , height: UIScreen.main.bounds.height)
    .environment(CommunityStore())
}
