//
//  ContentView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthStore.self) var authStore: AuthStore
    
    var body: some View {
        if authStore.isLogin {
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
