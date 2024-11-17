//
//  NavigationManager.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
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
