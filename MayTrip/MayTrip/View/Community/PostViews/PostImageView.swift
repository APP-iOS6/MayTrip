//
//  PostTopImageView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostImageView: View {
    @State private var currentPage = 0
    var post: PostUserVer
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            TabView {
                ForEach(Array(post.image.enumerated()), id: \.element) { index, image in
                    imageView(image: image, width: screenWidth, height: screenHeight)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .background(Color(uiColor: .systemGray6))
        }
    }
}

extension PostImageView {
    @ViewBuilder
    func imageView(image: UIImage, width: CGFloat, height: CGFloat) -> some View { // 이미지 갯수에 따른 배치 수정
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: getRatio(image: image) >= 8/3 ? .fit : .fill)
            .scaledToFit()
            .frame(width: width)
            .clipped()
    }
    
    private func getRatio(image: UIImage) -> Double {
        return image.size.width / image.size.height
    }
}
