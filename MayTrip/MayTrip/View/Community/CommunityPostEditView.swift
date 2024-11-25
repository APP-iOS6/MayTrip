//
//  CommunityAddPostView.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI
import PhotosUI

struct CommunityPostEditView: View {
    private enum addPostCategory: String, CaseIterable {
        case question = "질문", findCompanion = "동행찾기", tripReview = "여행후기", recommandRestaurant = "맛집추천"
    }
    
    let userStore = UserStore.shared
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var text: String = ""
    @State private var postCategory: addPostCategory = .question
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var isUploading: Bool = false
    @State private var isShowingRouteSheet: Bool = false
    @State private var selectedRouteID: Int? = nil
    @State private var selectedRoute: TripRouteSimple? = nil
    @FocusState private var isFocused: Bool
    private let categories: [addPostCategory] = [.question, .findCompanion, .tripReview, .recommandRestaurant]
//    let post: PostUserVer
    
    private var tagArray: [String] {
        var tags = tags.components(separatedBy: "#").filter{ $0 != "" }
        for i in 0..<tags.count {
            tags[i] = tags[i].components(separatedBy: "#").joined().trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return tags
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
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
                            .focused($isFocused)
                        
                        Divider()
                        
                        TextField("#을 이용해 태그를 입력해주세요", text: $tags)
                            .padding(.vertical, 6)
                            .keyboardType(.twitter)
                            .focused($isFocused)
                        
                        Divider()
                        
                        HStack {
                            Button {
                                isShowingRouteSheet.toggle()
                            } label: {
                                HStack {
                                    if let selectedRouteID = selectedRouteID {
                                        let title = tripRouteStore.myTripRoutes.filter{ $0.id == selectedRouteID }.first!.title
                                        Text(title)
                                    } else {
                                        HStack {
                                            Text("여행루트를 선택해주세요")
                                        }
                                    }
                                    Image(systemName: "chevron.right")
                                    Spacer()
                                }
                            }
                            .foregroundStyle(selectedRouteID == nil ? Color(uiColor: .systemGray3) : .primary)
                            
                            Spacer()
                            
                            if let selectedRouteID = selectedRouteID {
                                Button {
                                    self.selectedRouteID = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .foregroundStyle(Color(uiColor: .systemGray3))
                            }
                        }
                        .padding(.vertical, 6)
                        
                        Divider()
                        
                        TextField("내용을 입력해주세요", text: $text, axis: .vertical)
                            .padding(.vertical, 6)
                            .focused($isFocused)
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
                                        Image(systemName: "photo.badge.plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundStyle(Color(uiColor: .systemGray3))
                                            .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.2)
                                    }
                                    .onChange(of: selectedPhotos) {
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
                if isUploading {
                    ProgressView()
                        .frame(width: proxy.size.width, height: proxy.size.height * 1.3)
                        .background(.clear)
                        .ignoresSafeArea()
                }
            }
            .scrollDisabled(!isFocused)
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("게시글 편집")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            self.title = communityStore.selectedPost.title
            self.text = communityStore.selectedPost.text
            self.postCategory = getCategory(category: communityStore.selectedPost.category)
            self.images = communityStore.selectedPost.image
            if let tag = communityStore.selectedPost.tag {
                self.tags = tag.reduce("") {$0 + "#\($1) "}
            }
            if let tripRoute = communityStore.selectedPost.tripRoute {
                self.selectedRouteID = tripRoute.id
            }
        }
        .sheet(isPresented: $isShowingRouteSheet) {
            RouteSelectSheetView(selectedRouteID: $selectedRouteID, selectedRoute: $selectedRoute, isShowingRouteSheet: $isShowingRouteSheet)
                .presentationDetents([.height(500)])
                .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task {
                        isUploading = true
                        await communityStore.editPost(/*post: post, */title: title, text: text, image: images, category: postCategory.rawValue, tag: tagArray, tripRoute: selectedRoute)
                        isUploading = false
                        dismiss()
                    }
                } label: {
                    Text("완료")
                        .foregroundStyle(title.isEmpty || text.isEmpty ? Color.gray : Color("accentColor"))
                }
                .disabled(title.isEmpty || text.isEmpty || isUploading)
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    isFocused = false
                } label: {
                    Text("닫기")
                }
            }
        }
    }
    
    private func getCategory(category: Int) -> addPostCategory {
        switch category {
        case 1:
            return .question
        case 2:
            return .findCompanion
        case 3:
            return .tripReview
        case 4:
            return .recommandRestaurant
        default:
            return .question
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
                    if result.1 != nil {
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
