//
//  MyPageViewCommon.swift
//  MayTrip
//
//  Created by 강승우 on 11/8/24.
//

import SwiftUI

extension MyPageView{
    func manageButtonLabel(image: String, text: String, width: CGFloat) -> some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height:width * 0.1)
                .foregroundStyle(.black)
            Text(text)
                .foregroundStyle(.black)
        }
        .opacity(0.7)
    }
    
    func listButtonLabel(image: String, text: String) -> some View {
        HStack {
            if !image.isEmpty {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            Text(text)
        }
        .padding(.vertical, 5)
    }
    
}
