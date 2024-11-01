//
//  LoginView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct LoginView : View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body : some View {
        VStack {
            VStack {
                Image("appIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.3)
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.3)
            }
            .padding(.top, screenHeight * 0.06)
            .padding(.bottom, screenHeight * 0.08)
            
            SignInView()
                .frame(width: screenWidth, height: screenHeight * 0.5)
        }
    }
}

#Preview {
    LoginView()
}
