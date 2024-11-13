//
//  CommunityStore.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

@Observable
class CommunityStore {
    var posts: [Post] = [
        Post(id: 1, title: "가제", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", author: User(id: 5, nickname: "가명", profileImage: nil, email: "test@test.com", exp: 0, provider: "email"), images: ["appLogo", "appleLogo", "appleLogo", "appleLogo", "appleLogo"], category: "여행후기", tripRoute: nil, createAt: Date(), reply: 0, store: 0),
        Post(id: 2, title: "가제", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", author: User(id: 1, nickname: "가명", profileImage: nil, email: "test@test.com", exp: 0, provider: "email"), images: ["appleLogo", "appleLogo", "appleLogo", "appleLogo"], category: "여행후기", tripRoute: nil, createAt: Date(), reply: 0, store: 0),
        Post(id: 3, title: "가제", text: "본문", author: User(id: 1, nickname: "가명", profileImage: nil, email: "test@test.com", exp: 0, provider: "email"), images: ["appLogo", "appLogo", "appLogo", "appleLogo", "appleLogo"], category: "여행후기", tripRoute: nil, createAt: Date(), reply: 0, store: 0),
        Post(id: 4, title: "가제", text: "본문", author: User(id: 1, nickname: "가명", profileImage: nil, email: "test@test.com", exp: 0, provider: "email"), images: [], category: "여행후기", tripRoute: nil, createAt: Date(), reply: 0, store: 0),
        Post(id: 5, title: "가제", text: "본문", author: User(id: 1, nickname: "가명", profileImage: nil, email: "test@test.com", exp: 0, provider: "email"), images: [], category: "여행후기", tripRoute: nil, createAt: Date(), reply: 0, store: 0),
    ]
    
    init() {
        updatePostOrder()
    }
    
    func addPost(title: String, text: String, author: User, category: String) {
        let newPost = Post(id: posts.count + 1, title: title, text: text, author: author, images: [], category: category, tripRoute: nil, createAt: Date(), reply: 0, store: 0)
        posts = [newPost] + posts
    }
    
    func updatePostOrder() {
        posts = posts.sorted { $0.createAt > $1.createAt }
    }
}
