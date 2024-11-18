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
    @State var isCheckNickanme: Bool = false
    @State var errorMessage: String = ""
    @FocusState private var focusField: Field?
    let userStore = UserStore.shared
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: height * 0.05) {
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
                    .padding(.top, height * 0.15)
                    .padding(.bottom, height * 0.1)
                    
                    HStack(spacing: 20) {
                        CreateLoginViewTextField(text: $nickname, symbolName: "", placeholder: "닉네임을 입력해주세요", width: width * 0.6, height: height * 0.06, isSecure: false, isFocused: false, isEmail: false)
                            .focused($focusField, equals: .nickname)
                            .onChange(of: nickname) {
                                isCheckNickanme = false
                                errorMessage = ""
                            }
                        
                        Button {
                            checkNicknameValid()
                        } label: {
                            Text("중복확인")
                                .foregroundStyle(.white)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color.accent)
                                        .frame(width: width * 0.2, height: height * 0.06)
                                }
                        }
                    }
                    HStack {
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundStyle(errorMessage == "사용 가능한 닉네임입니다" ? .blue : .red)
                        }
                        Spacer()
                    }
                    .frame(width: width * 0.7 + 25)
                    .offset(y:-height * 0.04)
                    
                    Spacer()
                }
                .frame(width: width, height: height * 0.95)
            }
            .ignoresSafeArea(.keyboard)
            .scrollDisabled(focusField == nil)
            .toolbar {
                toolbarView
            }
        }
    }
    
    private var toolbarView: some View {
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
                clickApplyButton()
            } label : {
                Text("적용")
                    .font(.system(size: 18))
                    .frame(width: width * 0.1)
            }
        }
        .frame(width: width * 0.9)
    }
    
    private func checkNicknameValid() {
        Task {
            isCheckNickanme = true
            if nickname.isEmpty {
                errorMessage = "닉네임을 입력해주세요"
            }
            else if try await authStore.checkNickname(nickname: nickname) {
                isValid = true
                errorMessage = "사용 가능한 닉네임입니다"
            } else {
                isValid = false
                errorMessage = "이미 사용중인 닉네임입니다"
            }
        }
    }
    
    private func clickApplyButton() {
        if !isCheckNickanme {
            errorMessage = "닉네임 중복검사를 해주세요"
        } else if isValid && isCheckNickanme{
            Task {
                try await userStore.setUserInfo(
                    nickname: nickname,
                    image: profileImage
                )
                if !userStore.user.nickname.isEmpty {
                    authStore.isFirstLogin = false
                }
            }
        }
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
