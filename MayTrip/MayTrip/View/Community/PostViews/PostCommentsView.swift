//
//  PostCommentsView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostCommentsView: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 30) {
            ForEach(0..<3, id: \.self) { _ in
                CommentView(width: width, height: height)
            }
        }
        .padding()
    }
}
