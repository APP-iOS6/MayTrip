//
//  CommunityAddPostView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI
import PhotosUI

struct CommunityPostAddView: View {
    private enum addPostCategory: String, CaseIterable {
        case question = "질문", findCompanion = "동행찾기", tripReview = "여행후기", recommandRestaurant = "맛집추천"
    }
    
    let userStore = UserStore.shared
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var text: String = ""
    @State private var postCategory: addPostCategory = .question
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    private let categories: [addPostCategory] = [.question, .findCompanion, .tripReview, .recommandRestaurant]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Picker("", selection: $postCategory) {
                            ForEach(addPostCategory.allCases, id:\.self) {
                                Text($0.rawValue)
                            }
                        }
                        .accentColor(.black)
                        .padding(.horizontal, -12)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    TextField("제목을 입력해주세요", text: $title)
                        .padding(.vertical, 6)
                    
                    Divider()
                    
                    TextField("#을 이용해 태그를 입력해주세요", text: $tags)
                        .padding(.vertical, 6)
                        .keyboardType(.twitter)
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("여행루트를 선택해주세요")
                            Spacer()
                        }
                    }
                    .foregroundStyle(Color(uiColor: .systemGray3))
                    .padding(.vertical, 6)
                    
                    Divider()
                    
                    TextField("내용을 입력해주세요", text: $text, axis: .vertical)
                        .padding(.vertical, 6)
                        .frame(width: proxy.size.width * 0.9, height: proxy.size.height * 0.4, alignment: .top)
                    
                    Divider()
                    
                    HStack {
                        Text("사진")
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: proxy.size.width * 0.05) {
                            ForEach(images, id:\.self) { image in
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: image.size.width > image.size.height ? .fill : .fit)
                                        .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.2)
                                        .clipped()
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button {
                                                images = images.filter {
                                                    $0 != image
                                                }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .frame(width: proxy.size.width * 0.05, height: proxy.size.width * 0.05)
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                        .frame(width: proxy.size.width * 0.23)
                                        Spacer()
                                    }
                                    .frame(width : proxy.size.width * 0.23, height: proxy.size.width * 0.23)
                                }
                            }
                            
                            if images.count < 5 {
                                PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5 - images.count , matching: .images) {
                                    
                                    VStack {
                                        Text("Add Images..")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color(uiColor: .systemGray3))
                                        Image(systemName: "plus")
                                            .resizable()
                                            .foregroundStyle(Color(uiColor: .systemGray3))
                                            .frame(width: proxy.size.width * 0.05, height: proxy.size.width * 0.05)
                                    }
                                    .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.2)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(uiColor: .systemGray3), style: .init(dash: [10]))
                                    }
                                }
                                .onChange(of: selectedPhotos) { _ in
                                    loadSelectedPhotos()
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(height : proxy.size.width * 0.25)
                    }
                }
                .padding(.horizontal, proxy.size.width * 0.05)
                .frame(width: proxy.size.width)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("게시글 작성")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task {
                        try await communityStore.addPost(title: title, text: text, author: userStore.user, category: postCategory.rawValue)
                        dismiss()
                    }
                } label: {
                    Text("완료")
                        .foregroundStyle(title.isEmpty || text.isEmpty ? Color.gray : Color("accentColor"))
                }
                .disabled(title.isEmpty || text.isEmpty)
            }
        }
    }
    
    private func loadSelectedPhotos() { // 이미지 추가 함수
        Task {
            await withTaskGroup(of: (UIImage?, Error?).self) { taskGroup in
                for photoItem in selectedPhotos {
                    taskGroup.addTask {
                        do {
                            if let imageData = try await photoItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: imageData) {
                                return (image, nil)
                            }
                            return (nil, nil)
                        } catch {
                            return (nil, error)
                        }
                    }
                }
                
                for await result in taskGroup {
                    if let error = result.1 {
                        break
                    } else if let image = result.0 {
                        images.append(image)
                    }
                }
                selectedPhotos.removeAll()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunityPostAddView()
    }
}
