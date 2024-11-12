//
//  MainView.swift
//  MayTrip
//
//  Created by 강승우 on 11/6/24.
//

import SwiftUI

struct MainView:  View {
    @State private var selection = 0
    @Environment(AuthStore.self) var authStore: AuthStore
    let userStore = UserStore.shared
    
    var body: some View {
        if authStore.isFirstLogin {
            ProfileInitView()
        } else {
            TabView(selection: $selection) {
                TripRouteView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("여행")
                    }
                    .tag(0)
                
                CommunityView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("커뮤니티")
                    }
                    .tag(1)
                
                ChatView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("채팅")
                    }
                    .tag(2)
                
                StorageView()
                    .tabItem {
                       Image(systemName: "bookmark")
                        Text("보관함")
                    }
                    .tag(3)
                
                MyPageView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("마이페이지")
                    }
                    .tag(4)
            }
        }
    }
}

#Preview {
    MainView()
}
