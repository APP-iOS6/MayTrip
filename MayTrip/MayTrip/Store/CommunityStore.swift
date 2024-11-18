//
//  CommunityStore.swift
//  MayTrip
//
//  Created by 강승우 on 11/11/24.
//

import SwiftUI

@Observable
class CommunityStore {
    let DB = DBConnection.shared
    
    var posts: [PostUserVer] = []
    var postsForDB: [Post] = []
    
    func addPost(title: String, text: String, author: User, category: String) async { // 게시물 작성
        let categoryNumber = getCategoryNumber(category: category)
        
        do {
            let postDB: PostDB = PostDB(title: title, text: text, author: author.id, image: "", category: categoryNumber)
            try await DB.from("POST").insert(postDB).execute()
            try await updatePost()
        } catch {
            print("Fail to add content: \(error)")
        }
    }
    
    func updatePost() async throws { // 업데이트된 DB로부터 게시물 불러오기 현재는 최신순으로 해놨는데 나중에 정렬 기준을 받아서 그에 맞춰서도 가능
        postsForDB = try await DB.from("POST").select().execute().value
        postsForDB = postsForDB.sorted { $0.id > $1.id }
        
        posts = []
        for post in postsForDB {
            let userInfo = try await getUserInfo(userID: post.author)
            
            posts.append(PostUserVer(id: post.id, title: post.title, text: post.text, author: userInfo!, image: post.image, category: post.category, createAt: post.createAt, updateAt: post.updateAt))
        }
    }
    
    private func getCategoryNumber(category: String) -> Int {
        switch category {
        case "질문" :
            return 1
        case "동행찾기" :
            return 2
        case "여행후기":
            return 3
        case "맛집추천":
            return 4
        default:
            return 0
        }
    }
    
    private func getUserInfo(userID: Int) async throws -> User? { // 게시물의 유저id로부터 유저 프로필 받아오기용
        var findUser: User?
        do {
            let result: [User] = try await DB.from("USER").select(
                """
                id,
                nickname,
                profile_image,
                email,
                exp,
                provider
                """
            ).eq("id", value:userID).execute().value
            if result.isEmpty {
                print("No data found for userID \(userID)")
                return nil
            }
            findUser = result[0]
            return findUser
        } catch {
            print(error)
            return nil
        }
    }
}
