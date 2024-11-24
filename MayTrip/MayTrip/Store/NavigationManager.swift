//
//  NavigationManager.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var tripPath = NavigationPath()
    @Published var communityPath = NavigationPath()
    @Published var chatPath = NavigationPath()
    @Published var storagePath = NavigationPath()
    @Published var myPagePath = NavigationPath()
    @Published var selection = 0
    
    func popToRoot() {
        switch selection {
        case 0:
            tripPath = NavigationPath()
        case 1:
            communityPath = NavigationPath()
        case 2:
            chatPath = NavigationPath()
        case 3:
            storagePath = NavigationPath()
        case 4:
            myPagePath = NavigationPath()
        default:
            break
        }
    }
    
    func pop() {
        switch selection {
        case 0:
            if !tripPath.isEmpty {
                tripPath.removeLast()
            }
        case 1:
            if !communityPath.isEmpty {
                communityPath.removeLast()
            }
        case 2:
            if !chatPath.isEmpty {
                chatPath.removeLast()
            }
        case 3:
            if !storagePath.isEmpty {
                storagePath.removeLast()
            }
        case 4:
            if !myPagePath.isEmpty {
                myPagePath.removeLast()
            }
        default:
            break
        }
        
    }
    
    func push(_ view: Destination) {
        switch selection {
        case 0:
            tripPath.append(view)
        case 1:
            communityPath.append(view)
        case 2:
            chatPath.append(view)
        case 3:
            storagePath.append(view)
        case 4:
            myPagePath.append(view)
        default:
            break
        }
    }
}

