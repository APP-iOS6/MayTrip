//
//  MayTripApp.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

@main
struct MayTripApp: App {
    let DB = DBConnection.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    DB.auth.handle(url)
                }
        }
    }
}
