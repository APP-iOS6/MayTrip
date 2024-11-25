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
    let storageStore = StorageStore.shared
    
    var posts: [PostUserVer] = []
    var myPosts: [PostUserVer] = []
    var postsForDB: [Post] = []
    var isUpadting: Bool = true
    
    func addPost(title: String, text: String, author: User, image: [UIImage], category: String) async { // 게시물 작성
        isUpadting = true
        let categoryNumber = getCategoryNumber(category: category)
        
        do {
            let images = try await storageStore.uploadImage(images: image)
            let postDB: PostDB = PostDB(title: title, text: text, author: author.id, image: images, category: categoryNumber)
            
            try await DB.from("POST").insert(postDB).execute()
            try await updatePost()
            
            posts.sort(by: {$0.createAt > $1.createAt})
        } catch {
            print("Fail to add content: \(error)")
        }
    }
    
    func editPost(post: PostUserVer, title: String, text: String, image: [UIImage], category: String) async {
        isUpadting = true
        let categoryNumber = getCategoryNumber(category: category)
        
        do {
            let images = try await storageStore.uploadImage(images: image)
            let postForUpdate = PostForDB(title: title, text: text, author: post.author.id, image: images, category: categoryNumber, createAt: post.createAt, updateAt: Date())
            
            try await DB.from("POST")
                .upsert(postForUpdate)
                .eq("id", value: post.id)
                .execute()
            try await updatePost()
            
            posts.sort(by: {$0.createAt > $1.createAt})
        } catch {
            print("Fail to add content: \(error)")
        }
    }
    
    func updatePost() async throws { // 업데이트된 DB로부터 게시물 불러오기 현재는 최신순으로 해놨는데 나중에 정렬 기준을 받아서 그에 맞춰서도 가능
        do {
            postsForDB = try await DB.from("POST").select().execute().value
            postsForDB = postsForDB.sorted { $0.id > $1.id }
            
            posts = []
            for post in postsForDB {
                let userInfo = try await getUserInfo(userID: post.author)
                let images = try await storageStore.getImages(pathes: post.image)
                
                posts.append(PostUserVer(id: post.id, title: post.title, text: post.text, author: userInfo!, image: images, category: post.category, createAt: post.createAt, updateAt: post.updateAt))
            }
            
            isUpadting = false
        } catch {
            print(error)
        }
    }
    
    // 게시글 삭제 함수
    func deletePost(postId: Int) async throws {
        try await DB.from("POST").delete().eq("id", value: postId).execute()
        
        posts = posts.filter {
            $0.id != postId
        }
    }
    
    func getUserPost() async throws {
        do {
            let postsDB: [Post] = try await DB
                .from("POST")
                .select()
                .eq("write_user", value: UserStore.shared.user.id)
                .execute()
                .value
            
            myPosts = []
            for post in postsDB {
                let userInfo = try await getUserInfo(userID: post.author)
                let images = try await storageStore.getImages(pathes: post.image)
                
                myPosts.append(PostUserVer(id: post.id, title: post.title, text: post.text, author: userInfo!, image: images, category: post.category, createAt: post.createAt, updateAt: post.updateAt))
            }
        } catch {
            print(error)
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
