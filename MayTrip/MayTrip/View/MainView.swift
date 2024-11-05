//
//  MainView.swift
//  MayTrip
//
//  Created by 강승우 on 11/6/24.
//

import SwiftUI

struct MainView:  View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            TripRouteView()
                .tabItem {
                    Image(selection == 0 ? "homeClick" : "homeUnClick")
                    Text("홈")
                }
                .tag(0)
            
            CommunityView()
                .tabItem {
                    Image(selection == 1 ? "communityClick" : "communityUnClick")
                    Text("커뮤니티")
                }
                .tag(1)
            
            ChatView()
                .tabItem {
                    Image(selection == 2 ? "chatClick" : "chatUnClick")
                    Text("채팅")
                }
                .tag(2)
            
            StorageView()
                .tabItem {
                    Image(selection == 3 ? "storageClick" : "storageUnClick")
                    Text("보관함")
                }
                .tag(3)
            
            MyPageView()
                .tabItem {
                    Image(selection == 4 ? "mypageClick" : "mypageUnClick")
                    Text("마이페이지")
                }
                .tag(4)
        }
    }
}

#Preview {
    MainView()
}
