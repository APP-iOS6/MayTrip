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
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height:width * 0.1)
            Text(text)
                .foregroundStyle(Color(uiColor: .systemGray))
        }
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
