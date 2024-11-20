//
//  MainView.swift
//  MayTrip
//
//  Created by 강승우 on 11/6/24.
//

import SwiftUI

struct MainView:  View {
    @State var selection: Int = 0
    @Environment(AuthStore.self) var authStore: AuthStore
    @Environment(ChatStore.self) var chatStore: ChatStore
    @EnvironmentObject var navigationManager: NavigationManager
    let userStore = UserStore.shared
    
    var body: some View {
        if authStore.isFirstLogin {
            ProfileInitView()
        } else {
            TabView(selection: $selection) {
                NavigationStack(path: $navigationManager.path) {
                    TripRouteView()
                        .navigationDestination(for: Destination.self) { destination in
                            handleDestination(destination)
                        }
                }
                .tabItem {
                    Image(systemName: selection == 0 ? "map.fill" : "map")
                        .environment(\.symbolVariants, .none)
                    Text("여행")
                }
                
                .tag(0)
                
                NavigationStack(path: $navigationManager.communityPath) {
                    CommunityView()
                        .navigationDestination(for: Destination.self) { destination in
                            handleDestination(destination)
                        }
                }
                .tabItem {
                    Image(systemName: selection == 1 ? "person.2.fill" : "person.2")
                        .environment(\.symbolVariants, .none)
                    Text("커뮤니티")
                }
                .tag(1)
                
                NavigationStack(path: $navigationManager.chatPath) {
                    ChatView()
                        .navigationDestination(for: Destination.self) { destination in
                            handleDestination(destination)
                        }
                }
                .tabItem {
                    Image(systemName: selection == 2 ? "message.fill" : "message")
                        .environment(\.symbolVariants, .none)
                    Text("채팅")
                }
                .tag(2)
                .onAppear {
                    Task {
                        try await chatStore.setAllComponents()
                    }
                }
                
                NavigationStack(path: $navigationManager.path) {
                    StorageView()
                        .navigationDestination(for: Destination.self) { destination in
                            handleDestination(destination)
                        }
                }
                .tabItem {
                    Image(systemName: selection == 3 ? "bookmark.fill" : "bookmark")
                        .environment(\.symbolVariants, .none)
                    Text("보관함")
                }
                .tag(3)
                
                NavigationStack(path: $navigationManager.path) {
                    MyPageView()
                        .navigationDestination(for: Destination.self) { destination in
                            handleDestination(destination)
                        }
                }
                .tabItem {
                    Image(systemName: selection == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, .none)
                    Text("마이페이지")
                }
                .tag(4)
            }
            .onChange(of: navigationManager.selection) {
                selection = navigationManager.selection
            }
            .onChange(of: selection) { previous, newValue in
                if previous == newValue {
                    navigationManager.popToRoot()
                } else {
                    navigationManager.selection = selection
                }
            }
        }
    }
    
    @ViewBuilder
    func handleDestination(_ destination: Destination) -> some View {
        switch destination {
        case .enterBasicInfo(let tripRoute):
            EnterBasicInformationView(tripRoute: tripRoute)
        case .placeAdd(let title, let tags, let tripRoute):
            PlaceAddingView(title: title, tags: tags, tripRoute: tripRoute)
        case .routeDetail(let tripRoute):
            RouteDetailView(tripRoute: tripRoute)
        case .chatRoom(let chatRoom, let user):
            ChattingRoomView(chatRoom: chatRoom, otherUser: user)
        case .enterBasic:
            EnterBasicInformationView()
        case .postDetail(let post, let tripRouteId):
            PostDetailView(post: post, tripRouteId: tripRouteId)
        }
    }
}

#Preview {
    MainView()
}
