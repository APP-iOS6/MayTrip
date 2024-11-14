//
//  ProfileInitView.swift
//  MayTrip
//
//  Created by 강승우 on 11/7/24.
//

import SwiftUI
import PhotosUI

struct ProfileInitView: View {
    private enum Field : Hashable{
        case nickname
    }
    
    @Environment(AuthStore.self) var authStore: AuthStore
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State var nickname:String = ""
    @State private var profileImage: UIImage?
    @State var isValid: Bool = false
    @State var errorMessage: String = ""
    @FocusState private var focusField: Field?
    let userStore = UserStore.shared
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: height * 0.05) {
                HStack {
                    Button {
                        
                    } label : {
                        ZStack {
                            Rectangle()
                                .frame(width: width * 0.1, height: 1)
                                .foregroundStyle(.clear)
                        }
                    }
                    
                    Spacer()
                    
                    Text("프로필")
                        .font(.system(size: 24))
                    
                    Spacer()
                    
                    Button {
                        if(nickname.isEmpty) {
                            errorMessage = "닉네임을 입력해주세요"
                        } else if !isValid {
                            errorMessage = "닉네임 중복확인을 해주세요"
                        } else {
                            Task {
                                try await userStore.setUserInfo(nickname: nickname, image: profileImage)
                                if !userStore.user.nickname.isEmpty {
                                    authStore.isFirstLogin = false
                                }
                            }
                        }
                    } label : {
                        Text("적용")
                            .font(.system(size: 18))
                            .frame(width: width * 0.1)
                    }
                }
                .frame(width: width * 0.9)
//                .padding(.top, height * 0.08)
                .padding(.bottom, height * 0.15)
                
                PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
                    if let image = profileImage {
                        ZStack {
                            Rectangle()
                                .frame(width: width * 0.4, height: width * 0.4)
                                .foregroundStyle(.clear)
                            
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: width * 0.4, height: width * 0.4)
                                .clipShape(.circle)
                        }
                    } else {
                        ZStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.accent.opacity(0.6))
                                .frame(width: width * 0.3, height: width * 0.3)
                                .padding(50)
                                .background {
                                    Rectangle()
                                        .foregroundStyle(Color.accent.opacity(0.3))
                                }
                                .clipShape(.circle)
                            
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color(uiColor: .systemGray))
                                .frame(width: width * 0.15)
                                .offset(x:width * 0.18, y: width * 0.18)
                        }
                        .frame(width: width * 0.4, height: width * 0.4)
                    }
                }
                .onChange(of: selectedPhotos) { _ in
                    loadSelectedPhotos()
                }
                .padding(.bottom, height * 0.1)
                
                HStack(spacing: 20) {
                    CreateLoginViewTextField(text: $nickname, symbolName: "", placeholder: "닉네임을 입력해주세요", width: width * 0.6, height: height * 0.08, isSecure: false, isFocused: false)
                        .focused($focusField, equals: .nickname)
                    
                    Button {
                        if !nickname.isEmpty {
                            errorMessage = ""
                            isValid = true // 추후에 검사 함수 추가하기
                        } else {
                            errorMessage = "닉네임을 입력해주세요"
                        }
                    } label: {
                        Text("중복확인")
                            .foregroundStyle(.white)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color.accent)
                                    .frame(width: width * 0.2, height: height * 0.08)
                            }
                    }
                }
                HStack {
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.red.opacity(0.7))
                    }
                    Spacer()
                }
                .frame(width: width * 0.7 + 25)
                .offset(y:-height * 0.04)
                
                Spacer()
            }
            .frame(width: width, height: height)
        }
        .ignoresSafeArea(.keyboard)
        .scrollDisabled(focusField == nil)
    }
    
    private func loadSelectedPhotos() {
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
                        profileImage = image
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileInitView()
}
