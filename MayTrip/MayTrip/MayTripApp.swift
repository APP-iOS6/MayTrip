//
//  MayTripApp.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct MayTripApp: App {
    
    @StateObject var authStore = AuthStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authStore)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        authStore.DB.auth.handle(url)
                    }
                }
        }
    }
}
