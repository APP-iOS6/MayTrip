//
//  RecommendContentView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI

struct RecommendContentView: View {
    var body: some View {
        NavigationLink {
            // 디테일 뷰 이동
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("여유롭게 즐기는 오사카 브런치카페") //루트 이름
                        .bold()
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("일본 오사카")
                    Text("4박 5일 일정")
                }
                .padding(.vertical, 10)
                
                Text("#태그 #태그 #태그")
                    .font(.footnote)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .lightGray).opacity(0.3), lineWidth: 2)
            )
            .frame(width: 200)
        }
        .foregroundStyle(.black)
    }
}

#Preview {
    NavigationStack {
        RecommendContentView()
    }
}
