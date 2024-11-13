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
                        Image(systemName: selection == 0 ? "map.fill" : "map")
                            .environment(\.symbolVariants, .none)
                        Text("여행")
                    }
                    .tag(0)
                
                CommunityView()
                    .tabItem {
                        Image(systemName: selection == 1 ? "person.2.fill" : "person.2")
                            .environment(\.symbolVariants, .none)
                        Text("커뮤니티")
                    }
                    .tag(1)
                
                ChatView()
                    .tabItem {
                        Image(systemName: selection == 2 ? "message.fill" : "message")
                            .environment(\.symbolVariants, .none)
                        Text("채팅")
                    }
                    .tag(2)
                
                StorageView()
                    .tabItem {
                       Image(systemName: selection == 3 ? "bookmark.fill" : "bookmark")
                            .environment(\.symbolVariants, .none)
                        Text("보관함")
                    }
                    .tag(3)
                
                MyPageView()
                    .tabItem {
                        Image(systemName: selection == 4 ? "person.fill" : "person")
                            .environment(\.symbolVariants, .none)
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
