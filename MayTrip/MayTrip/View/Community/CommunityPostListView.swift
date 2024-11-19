//
//  CommunityPostListView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityPostListView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    let userStore = UserStore.shared
    let dateStore = DateStore.shared
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(communityStore.posts, id:\.id) { post in
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.07)
                            .foregroundStyle(Color.accent)
                            .padding(7)
                            .overlay {
                                Circle()
                                    .foregroundStyle(Color.accent.opacity(0.5))
                            }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                // TODO: categoryCode -> category값 변환해서 적용
                                Text("동행찾기")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.primary)
                                    }
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundStyle(.gray)
                                }
                            }
                            Text(post.author.nickname)
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        }
                    }
                    Text(post.title)
                        .font(.system(size: 22))
                        .bold()
                    
                    Text(post.text)
                        .lineLimit(3)
                        .font(.system(size: 16))
                    
//                    if post.images.count > 0 {
//                        imagesView(image: post.images, width: width, height: height)
//                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "message")
                                .foregroundStyle(.gray)
                            Text("0")
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Text(dateStore.timeAgo(from: post.updateAt))
                            .foregroundStyle(.gray)
                            .font(.system(size: 14))
                    }
                }
                .padding(.vertical, height * 0.02)
                .padding(.horizontal, width * 0.06)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(uiColor: .systemBackground))
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        CommunityView()
    }
        .environment(CommunityStore())
}

extension CommunityPostListView {
    @ViewBuilder
    func imagesView(image: [String], width: CGFloat, height: CGFloat) -> some View { // 이미지 갯수에 따른 배치 수정
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
                    .frame(width: width * 0.449, height: height*0.3)
                Image(image[1])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                    .frame(width: width * 0.449, height: height*0.3)
            }
        default:
            HStack(spacing: 5) {
                Image(image[0])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) ? .fit : .fill)
                    .frame(width: width * 0.449, height: height*0.3)
                VStack(spacing: 5) {
                    Image(image[1])
                        .resizable()
                        .aspectRatio(contentMode: getRatio(image: image[1]) ? .fit : .fill)
                        .frame(width: width * 0.449, height: height*0.15)
                    ZStack {
                        Image(image[2])
                            .resizable()
                            .aspectRatio(contentMode: getRatio(image: image[2]) ? .fit : .fill)
                            .frame(width: width * 0.449, height: height*0.15)
                        if count>3 {
                            Rectangle()
                                .frame(width: width * 0.449, height: height*0.15)
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
