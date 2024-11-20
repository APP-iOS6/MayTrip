//
//  NavigationManager.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var communityPath = NavigationPath()
    @Published var chatPath = NavigationPath()
    @Published var selection = 0
    
    func popToRoot() {
        switch selection {
        case 0:
            path = NavigationPath()
        case 1:
            communityPath = NavigationPath()
        case 2:
            chatPath = NavigationPath()
        default:
            break
        }
    }
    
    func pop() {
        switch selection {
        case 0:
            if !path.isEmpty {
                path.removeLast()
            }
        case 1:
            if !communityPath.isEmpty {
                communityPath.removeLast()
            }
        case 2:
            if !chatPath.isEmpty {
                chatPath.removeLast()
            }
        default:
            break
        }
        
    }
    
    func push(_ view: Destination) {
        switch selection {
        case 0:
            path.append(view)
        case 1:
            communityPath.append(view)
        case 2:
            chatPath.append(view)
        default:
            break
        }
    }
}

