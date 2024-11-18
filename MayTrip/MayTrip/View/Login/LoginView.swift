//
//  LoginView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct LoginView : View {
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body : some View {
        NavigationStack {
            SignInView()
                .frame(width: screenWidth, height: screenHeight)
        }
    }
}

#Preview {
    LoginView()
}
