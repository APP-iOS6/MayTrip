//
//  CommunityBodyView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityBodyView: View {
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
        }
    }
}
