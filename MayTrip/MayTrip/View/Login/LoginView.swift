//
//  LoginView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct LoginView : View {
    @State var isSignUp: Bool = false
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
            
            if isSignUp {
                SignUpView(isSignUp: $isSignUp)
                    .frame(width: screenWidth, height: screenHeight * 0.5)
            } else {
                SignInView(isSignUp: $isSignUp)
                    .frame(width: screenWidth, height: screenHeight * 0.5)
            }
        }
    }
}

#Preview {
    LoginView()
}
