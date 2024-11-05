//
//  MyTripCardView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//
import SwiftUI

struct MyTripCardView: View {
    // TODO: DB 연결해서 데이터 넣기
    var body: some View {
        NavigationLink {
            // TODO: 디테일 뷰 이동
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.tint, lineWidth: 1)
                .overlay {
                    // storke 쓰면 배경색이 안먹혀서 사각형 한번 더 그려줌
                    RoundedRectangle(cornerRadius: 10)
                    // 현재 여행 중인 카드만 진한 컬러로
//                        .foregroundStyle(.tint)
                        .foregroundStyle(.white)
                        .overlay {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("도쿄여행까지")
                                        
                                        Text("D-2")
                                            .foregroundStyle(.tint)
                                            
                                        Spacer()
                                    }
                                    .bold()
                                    
                                    HStack() {
                                        Text("일본 도쿄")
                                        Divider()
                                        Text("10.29(화) - 11.03(월)")
                                        Text("4박 5일")
                                            .fontWeight(.semibold)
                                    }
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            // 현재 여행 중인 카드만 진한 컬러로
                            .foregroundStyle(.black)
//                            .foregroundStyle(.white)
                            .padding()
                            .padding(.vertical)
                        }
                }
                .frame(width: 350, height: 100)
        }
        .padding(1)
    }
}

#Preview {
    NavigationStack {
        MyTripCardView()
    }
}
