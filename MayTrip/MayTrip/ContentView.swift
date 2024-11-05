//
//  ContentView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        if authStore.isLogin {
            Text("contents view")
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthStore())
}
