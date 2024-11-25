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
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var text: String = ""
    @State private var postCategory: addPostCategory = .question
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var imageStrs: [String] = []
    @State private var isUploading: Bool = false
    @State private var isShowingRouteSheet: Bool = false
    @State private var selectedRoute: TripRouteSimple? = nil
    @FocusState private var isFocused: Bool
    private let categories: [addPostCategory] = [.question, .findCompanion, .tripReview, .recommandRestaurant]
    
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
                                    if let selectedRoute = selectedRoute {
                                        let title = tripRouteStore.myTripRoutes.filter{ $0.id == selectedRoute.id }.first!.title
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
                            .foregroundStyle(selectedRoute == nil ? Color(uiColor: .systemGray3) : .primary)
                            
                            Spacer()
                            
                            if let selectedRoute = selectedRoute {
                                Button {
                                    self.selectedRoute = nil
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
        .padding(.top, 1)
        .sheet(isPresented: $isShowingRouteSheet) {
            RouteSelectSheetView(selectedRoute: $selectedRoute, isShowingRouteSheet: $isShowingRouteSheet)
                .presentationDetents([.height(500)])
                .presentationDragIndicator(.visible)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("게시글 작성")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false
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
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task {
                        isUploading = true
                        await communityStore.addPost(title: title, text: text, author: userStore.user, image: imageStrs, category: postCategory.rawValue, tag: tagArray, tripRoute: selectedRoute?.id)
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
                        let data = image.pngData()
                        if let imageStr = data?.base64EncodedString() {
                            self.imageStrs.append(imageStr)
                        }
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
