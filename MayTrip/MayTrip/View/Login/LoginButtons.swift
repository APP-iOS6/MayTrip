//
//  LoginButtons.swift
//  MayTrip
//
//  Created by 강승우 on 11/5/24.
//

import SwiftUI

func kakaoLoginButtonLabel(width: CGFloat) -> some View {
    ZStack {
        Circle()
            .foregroundStyle(Color(red: 254/255, green: 229/255, blue: 0))
            .frame(width: width * 0.15)
        Image("kakaoLogo")
    }
    .clipShape(.circle)
    .frame(width: width * 0.15)
}
