//
//  TopContentsView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI
import UIKit
import WebKit

struct TopContentsView: View {
    @State var index = 1
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        // TODO: 프로모션 컨텐츠 뷰 만들어야 함
//                        AsyncImage(url: URL(string: "")) { image in
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11 * 2)
//                        } placeholder: {
//                            ProgressView()
//                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    Text("\(index)/3")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color(uiColor: .darkGray))
                        }
                        .padding()
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
    }
}
