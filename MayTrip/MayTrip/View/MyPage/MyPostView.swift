//
//  MyPostView.swift
//  MayTrip
//
//  Created by 이소영 on 11/24/24.
//
import SwiftUI

struct MyPostView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var scrollPosition: CGPoint = .zero
    @State private var scrollIndex: Int = 0
    let dateStore = DateStore.shared
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(communityStore.myPosts, id:\.id) { post in
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing: 10) {
                                if let image = UserStore.convertStringToImage(post.author.profileImage) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width * 0.12)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: width * 0.12)
                                        .clipShape(Circle())
                                        .foregroundStyle(Color("accentColor").opacity(0.2))
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        // TODO: categoryCode -> category값 변환해서 적용
                                        Text(communityStore.getCategoryName(categoryNumber: post.category))
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
                                            communityStore.selectedPost = post
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
                            
//                            if post.image.count > 0 {
//                                ZStack {
//                                    ScrollView(.horizontal) {
//                                        LazyHStack(spacing: 0) {
//                                            ForEach(post.image, id: \.self) { image in
//                                                Image(uiImage: image)
//                                                    .resizable()
//                                                    .scaledToFit()
//                                                    .frame(width: width * 0.71, height: height * 0.3)
//                                                    .clipped()
//                                                    .padding(.horizontal, width * 0.05)
//                                                    .containerRelativeFrame(.horizontal, count: post.image.count, span: post.image.count, spacing: 0)
//                                            }
//                                        }
//                                        .background(GeometryReader { geometry in
//                                            Color.clear
//                                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
//                                        })
//                                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
//                                            self.scrollPosition = value
//                                            scrollIndex = Int((abs(value.x - width * 0.125) + width * 0.405) / (width * 0.81))
//                                        }
//                                    }
//                                    .scrollDisabled(post.image.count == 1)
//                                    
//                                    if post.image.count > 1 { // 이미지가 여러 개일 경우에만 페이징 보여주기
//                                        VStack {
//                                            Spacer()
//                                            HStack {
//                                                Spacer()
//                                                
//                                                HStack(spacing: 0) {
//                                                    Text("\(scrollIndex + 1)")
//                                                        .font(.system(size: 12))
//                                                        .foregroundStyle(.white)
//                                                    Text(" / \(post.image.count)")
//                                                        .font(.system(size: 12))
//                                                        .foregroundStyle(Color(uiColor: .systemGray5))
//                                                }
//                                                .padding(.vertical, 5)
//                                                .padding(.horizontal, 10)
//                                                .background {
//                                                    Capsule()
//                                                        .foregroundStyle(Color(uiColor: .systemGray2))
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                .frame(width: width * 0.81)
//                                .scrollTargetLayout()
//                                .scrollTargetBehavior(.paging)
//                                .safeAreaPadding(.bottom)
//                            }
                            
                            HStack {
                                HStack {
                                    Image(systemName: "message")
                                        .foregroundStyle(.gray)
                                    Text("\(communityStore.comments[post.id] != nil ? communityStore.comments[post.id]!.count : 0)")
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Text(dateStore.timeAgo(from: post.createAt))
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
                        .onTapGesture {
                            communityStore.selectedPost = post
                            navigationManager.push(.postDetail)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .onTapGesture {
                    isPresented = false
                }
                .sheet(isPresented: $isPresented) {
                    CommunityMenuSheetView(isPresented: $isPresented)
                        .presentationDetents([.height(170)])
                        .presentationDragIndicator(.visible)
                }
            }
            .padding(.vertical, 1)
            
            if communityStore.myPosts.count == 0 {
                Text("나의 게시물이 비어있습니다")
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                }
                .foregroundStyle(.black)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("나의 게시물")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension MyPostView {
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        }
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
