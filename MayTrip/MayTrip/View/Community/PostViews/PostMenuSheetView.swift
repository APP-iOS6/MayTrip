//
//  PostMenuSheetView.swift
//  MayTrip
//
//  Created by 최승호 on 11/20/24.
//

import SwiftUI

struct PostMenuSheetView: View {
    @Binding var isPresented: Bool
    @State var isPresentedDeleteAlert: Bool = false
    var selectedCommentOwner: Int
    var selectedCommentId: Int
    
    let userStore = UserStore.shared
    
    var body: some View {
        if userStore.user.id == selectedCommentOwner { // 제작자의 경우
            List {
                Button {
                    // TODO: 댓글 편집
                } label: {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("편집")
                    }
                    .foregroundStyle(.black)
                }
                
                Button {
                    isPresentedDeleteAlert = true // 삭제 확인용 알럿
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("삭제")
                    }
                    .foregroundStyle(.red)
                }
                .alert("게시물을 삭제하시겠습니까", isPresented: $isPresentedDeleteAlert) {
                    Button("취소", role: .cancel) {
                        isPresentedDeleteAlert = false
                    }
                    Button("삭제하기", role: .destructive) {
                        // TODO: 댓글 삭제
                        isPresentedDeleteAlert = false
                        isPresented = false
                    }
                }
            }
            .listStyle(.automatic)
            .listRowBackground(Color(uiColor: .systemGray4))
            .padding(.top, 25)
            .background(Color(uiColor: .systemGray6))
        } else {
            List {
                Button { // 대화걸기
                    
                } label: {
                    HStack {
                        Image(systemName: "message")
                        Text("대화걸기")
                    }
                    .foregroundStyle(.black)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.bubble")
                        Text("신고")
                    }
                    .foregroundStyle(.red)
                }
            }
            .listStyle(.automatic)
            .listRowBackground(Color(uiColor: .systemGray4))
            .padding(.top, 25)
            .background(Color(uiColor: .systemGray6))
        }
    }
}
