//
//  ChattingRoomView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct ChattingRoomView: View {
    @Environment(\.dismiss) var dismiss
    @State var message: String = ""
    @FocusState var focused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:  15)
                }
                Spacer()
                
                // 채팅 상대 이름
                Text("김철수")
                
                Spacer()
            }
            .foregroundStyle(.black)
            .font(.title3)
            .padding(.horizontal)
            
            Divider()
            
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section(header:
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                                .overlay {
                                    // storke 쓰면 배경색이 안먹혀서 사각형 한번 더 그려줌
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color(uiColor: .systemGray6))
                                        .overlay {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text("여행 같이 갈 분 구합니다")
                                                        .lineLimit(1)
                                                        .bold()
                                                        
                                                    HStack(spacing: 10) {
                                                        // 여행지
                                                        Text("일본 도쿄")
                                                        // 여행 날짜, 기간
                                                        Text("10.29(화) - 11.03(월)")
                                                        Text("4박 5일")
                                                    }
                                                    .font(.system(size: 15))
                                                    .foregroundStyle(.gray)
                                                    
                                                    Text("도쿄로 일본여행 같이 갈 분 구합니다")
                                                        .lineLimit(1)
                                                        .font(.system(size: 15))
                                                        .foregroundStyle(.gray)
                                                }
                                                
                                                Spacer()
                                            }
                                            // 현재 여행 중인 카드만 진한 컬러로
                                            .foregroundStyle(.black)
                //                            .foregroundStyle(.white)
                                            .padding()
                                            .padding(.vertical)
                                        }
                                }
                        
                        .padding([.horizontal, .top])
                        .background {
                            Rectangle()
                                .foregroundColor(.white)
                        }
                        .padding(.bottom)
                        .frame(width: .infinity, height: 130)
                    )
                    {
                        VStack(alignment: .center) {
                            Text("2024년 11월 04일")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .padding()
                            
                            ForEach(0..<4) { index in
                                // TODO: 상대가 보낸 메세지인지 분기 로직 추가
                                
                                // 내가 보낸 메세지
                                HStack(alignment: .bottom, spacing: 0) {
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("읽음")
                                        Text("오전 10:45")
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    
                                    Text("안녕하세요. 같이 여행가요. 이 루트로 여행 가는거 어떄요?")
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(.tint)
                                                .cornerRadius(10, corners: [.topLeft, .bottomLeft, .bottomRight])
                                        }
                                        .padding(.horizontal)
                                }
                                .padding(.bottom)
                                
                                // 상대가 보낸 메세지
                                HStack(alignment: .bottom, spacing: 0) {
                                    Text("안녕하세요. 같이 여행가는거 너무 좋아요")
                                        .foregroundStyle(.black)
                                        .padding()
                                        .background {
                                            Rectangle()
                                                .foregroundStyle(Color(uiColor: .systemGray6))
                                                .cornerRadius(10, corners: [.topLeft, .topRight, .bottomRight])
                                        }
                                        .padding(.horizontal)
                                    
                                    VStack(alignment: .leading) {
                                        Text("읽음")
                                        Text("오전 10:45")
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    
                                    Spacer()
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 15)
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            
            Spacer()
            
            Divider()
            
            HStack {
                TextField("메세지를 입력하세요", text: $message)
                    .onChange(of: message) { oldValue, newValue in
                        
                    }
                    .keyboardType(.default)
                    .focused($focused)
                
                Button {
                    message = ""
                    focused = false
                } label: {
                    VStack {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.tint)
                    }
                    .foregroundStyle(Color(uiColor: .gray))
                }
                .disabled(message.count == 0)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 1)
            )
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            focused = false
        }
    }
}

#Preview {
    ChattingRoomView()
}
