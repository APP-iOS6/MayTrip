//
//  NavigationManager.swift
//  MayTrip
//
//  Created by 강승우 on 11/13/24.
//

import SwiftUI


class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func push(_ view: Destination) {
        path.append(view)
    }
}
