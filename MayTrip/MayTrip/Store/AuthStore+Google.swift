//
//  AuthStore+Google.swift
//  MayTrip
//
//  Created by 강승우 on 11/7/24.
//

import SwiftUI
import GoogleSignIn
import Auth

extension AuthStore {
    func googleLogin() {
        guard let presentingViewController  = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else { return }
            
            guard let profile = result.user.profile else { return }
            Task {
                await self.successLogin(email: profile.email, provider: "google")
            }
        }
    }
}
