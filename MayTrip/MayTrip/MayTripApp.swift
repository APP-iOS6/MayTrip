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
    @StateObject var navigationManager = NavigationManager()
    @StateObject var tripRouteStore = TripRouteStore()
    @State var authStore = AuthStore()
    @State private var chatStore: ChatStore = .init()
    var communityStore = CommunityStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .environmentObject(tripRouteStore)
                .environment(authStore)
                .environment(communityStore)
                .environment(chatStore)
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                        authStore.DB.auth.handle(url)
                    }
                }
                .onAppear {
                    Task {
                        await authStore.checkAutoLogin()
                    }
                }
        }
    }
}
