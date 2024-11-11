//
//  MayTripApp.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon
import GoogleSignIn

@main
struct MayTripApp: App {
    
    var authStore = AuthStore()
    var communityStore = CommunityStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authStore)
                .environment(communityStore)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                        authStore.DB.auth.handle(url)
                    }
                }
        }
    }
}
