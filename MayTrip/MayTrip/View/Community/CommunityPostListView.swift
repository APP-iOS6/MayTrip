//
//  CommunityPostListView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityPostListView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(communityStore.posts, id:\.id) { post in
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.07)
                            .foregroundStyle(Color.accent)
                            .padding(5)
                            .overlay {
                                Circle()
                                    .foregroundStyle(Color.accent.opacity(0.5))
                            }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(post.author.nickname)
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundStyle(.gray)
                                }
                            }
                            Text(dateToString(date:post.createAt))
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                        .frame(width: width * 0.83 - 20, height: width * 0.07)
                    }
                    
                    Text(post.text)
                        .lineLimit(3)
                        .font(.system(size: 16))
                    
                    if post.images.count > 0 {
                        imagesView(image: post.images, width: width, height: height)
                    }
                    
                    HStack {
                        Spacer()
                        HStack {
                            Image("chatUnClick")
                            Text("\(post.reply)")
                                .foregroundStyle(.gray)
                        }
                        
                        HStack {
                            Image("storageUnClick")
                            Text("\(post.store)")
                                .foregroundStyle(.gray)
                        }
                        
                    }
                }
                .frame(width: width * 0.9)
                .padding(.vertical, height * 0.02)
                .padding(.horizontal, width * 0.05)
                .border(Color(uiColor:.systemGray3), width: 0.2)
            }
        }
    }
}

extension CommunityPostListView {
    @ViewBuilder
    func imagesView(image: [String], width: CGFloat, height: CGFloat) -> some View {
        let count = image.count
        
        switch count {
        case 1:
            Image(image[0])
                .resizable()
                .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                .frame(width: width * 0.9, height: height*0.3)
        case 2:
            HStack {
                Image(image[0])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                    .frame(width: width * 0.45, height: height*0.3)
                Image(image[1])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                    .frame(width: width * 0.45, height: height*0.3)
            }
        default:
            HStack(spacing: 5) {
                Image(image[0])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                    .frame(width: width * 0.45, height: height*0.3)
                VStack(spacing: 5) {
                    Image(image[1])
                        .resizable()
                        .aspectRatio(contentMode: getRatio(image: image[1]) ? .fit : .fill)
                        .frame(width: width * 0.45, height: height*0.15)
                    ZStack {
                        Image(image[2])
                            .resizable()
                            .aspectRatio(contentMode: getRatio(image: image[2]) ? .fit : .fill)
                            .frame(width: width * 0.45, height: height*0.15)
                        if count>3 {
                            Rectangle()
                                .frame(width: width * 0.45, height: height*0.15)
                                .foregroundStyle(.black.opacity(0.5))
                            Text("+\(count-3)")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
    
    
    private func getRatio(image: String) -> Bool {
        guard let uiImage = UIImage(named: image) else { return false }
        return uiImage.size.width >= uiImage.size.height
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
