//
//  CommunityPostListView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

struct CommunityPostListView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    let dateStore = DateStore.shared
    let width: CGFloat
    let height: CGFloat
    @State var isPresented: Bool = false
    @State var selectedPostOwner: Int = 0
    @State var selectedPostId: Int = 0
    
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
                                    isPresented = true
                                    selectedPostOwner = post.author.id
                                    selectedPostId = post.id
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
                    
                    if post.image.count > 0 {
                        imagesView(image: post.image, width: width, height: height)
                    }
                    
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
        .padding(.bottom, 20)
        .onTapGesture {
            isPresented = false
        }
        .sheet(isPresented: $isPresented) {
            CommunityMenuSheetView(isPresented: $isPresented, selectedPostOwner: $selectedPostOwner, selectedPostId: $selectedPostId)
                .presentationDetents([.height(170)])
                .presentationDragIndicator(.visible)
        }
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
    func imagesView(image: [UIImage], width: CGFloat, height: CGFloat) -> some View { // 이미지 갯수에 따른 배치 수정
        let count = image.count
        
        switch count {
        case 1:
            Image(uiImage:image[0])
                .resizable()
                .aspectRatio(contentMode: getRatio(image: image[0]) >= 8/3 ? .fit : .fill)
                .scaledToFit()
                .frame(width: width * 0.8, height: height*0.3)
                .clipped()
        case 2:
            HStack {
                Image(uiImage: image[0])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) >= 4/3 ? .fit : .fill)
                    .frame(width: width * 0.4, height: height*0.3)
                    .clipped()
                Image(uiImage: image[1])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[1]) >= 8/3 ? .fit : .fill)
                    .frame(width: width * 0.4, height: height*0.3)
                    .clipped()
            }
            .frame(width: width * 0.8, height: height*0.3)
        default: // 이미지 3개 이상일 때
            HStack(spacing: 0) {
                Image(uiImage: image[0])
                    .resizable()
                    .aspectRatio(contentMode: getRatio(image: image[0]) >= 4/3 ? .fit : .fill)
                    .frame(width: width * 0.4, height: height*0.3)
                    .clipped()
                VStack(spacing: 0) {
                    Image(uiImage: image[1])
                        .resizable()
                        .aspectRatio(contentMode: getRatio(image: image[1]) >= 8/3 ? .fit : .fill)
                        .frame(width: width * 0.4, height: height*0.15)
                        .clipped()
                    ZStack {
                        Image(uiImage: image[2])
                            .resizable()
                            .aspectRatio(contentMode: getRatio(image: image[2]) >= 8/3 ? .fit : .fill)
                            .frame(width: width * 0.4, height: height*0.15)
                            .clipped()
                        if count > 3 {
                            Rectangle()
                                .frame(width: width * 0.4, height: height*0.15)
                                .foregroundStyle(.black.opacity(0.5))
                            Text("+\(count-3)")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .frame(width: width * 0.8, height: height*0.3)
        }
    }
    
    private func getRatio(image: UIImage) -> Double {
        return image.size.width / image.size.height
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
