//
//  ChatView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        List {
            ForEach(0..<4) { index in
                HStack {
                    // 유저 프로필 이미지
                    Image(systemName: "square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("김철수")
                        
                        Text("안녕하세요")
                            .lineLimit(1)
                            .foregroundStyle(.gray)
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        // chat store timeDifference로 계산
                        Text("30분 전")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        
                        Circle()
                            .frame(width: 15, height: 15)
                            .overlay {
                                // 안읽은 메세지 카운트
                                Text("1")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                            }
                            .foregroundStyle(.orange)
                    }
                    .padding(.leading, 5)
                }
                .background {
                    NavigationLink(destination: ChattingRoomView()) {
                        
                    }
                    .opacity(0)
                }
                .swipeActions {
                    Button {
                        // TODO: 채팅방 나가기
                    } label: {
                        Image(systemName: "door.left.hand.open")
                    }
                    .tint(.red)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("채팅")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
