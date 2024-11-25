//
//  CommunityPostImageView.swift
//  MayTrip
//
//  Created by 강승우 on 11/24/24.
//

import SwiftUI

struct CommunityPostImageView: View {
    @State private var scrollPosition: CGPoint = .zero
    @State private var scrollIndex: Int = 0
    let post: PostUserVer
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(post.image, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.71, height: height * 0.3)
                            .clipped()
                            .padding(.horizontal, width * 0.05)
                            .containerRelativeFrame(.horizontal, count: post.image.count, span: post.image.count, spacing: 0)
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    self.scrollPosition = value
                    scrollIndex = Int((abs(value.x - width * 0.125) + width * 0.405) / (width * 0.81))
                }
            }
            .scrollDisabled(post.image.count == 1)
            
            if post.image.count > 1 { // 이미지가 여러 개일 경우에만 페이징 보여주기
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Text("\(scrollIndex + 1)")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                            Text(" / \(post.image.count)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(uiColor: .systemGray5))
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background {
                            Capsule()
                                .foregroundStyle(Color(uiColor: .systemGray2))
                        }
                    }
                }
            }
        }
        .frame(width: width * 0.81)
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .safeAreaPadding(.bottom)
    }
}

extension CommunityPostImageView {
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        }
    }
}
