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
    var selectedPost: PostUserVer = PostUserVer(id: 0, title: "", text: "", author: User(id: 0, nickname: "", profileImage: "", email: "", exp: 0, provider: ""), image: [], category: 0, tag: nil, tripRoute: nil, createAt: Date(), updateAt: Date())
    
    func addPost(title: String, text: String, author: User, image: [UIImage], category: String, tag: [String]? = nil, tripRoute: Int? = nil) async { // 게시물 작성
        isUpadting = true
        let categoryNumber = getCategoryNumber(category: category)
        
        do {
            let images = try await storageStore.uploadImage(images: image)
            let postDB: PostDB = PostDB(title: title, text: text, author: author.id, image: images, category: categoryNumber, tag: tag, tripRoute: tripRoute)
            
            try await DB.from("POST").insert(postDB).execute()
            try await updatePost()
            
            posts.sort(by: {$0.createAt > $1.createAt})
        } catch {
            print("Fail to add content: \(error)")
        }
    }
    
    func editPost(/*post: PostUserVer, */title: String, text: String, image: [UIImage], category: String, tag: [String]? = nil, tripRoute: TripRouteSimple? = nil) async {
        isUpadting = true
        let categoryNumber = getCategoryNumber(category: category)
        
        do {
            let images = try await storageStore.uploadImage(images: image)
            let postForUpdate = PostForDB(title: selectedPost.title, text: text, author: selectedPost.author.id, image: images, category: categoryNumber, tag: tag, tripRoute: tripRoute?.id, createAt: selectedPost.createAt, updateAt: Date())
            
            try await DB.from("POST")
                .update(postForUpdate)
                .eq("id", value: selectedPost.id)
                .execute()
            
            if tripRoute == nil {
                let nilRoute: [String: Int?] = ["trip_route": nil]
                try await DB.from("POST")
                    .update(nilRoute)
                    .eq("id", value: selectedPost.id)
                    .execute()
            }
            
            selectedPost = PostUserVer(id: selectedPost.id, title: postForUpdate.title, text: postForUpdate.text, author: selectedPost.author, image: image, category: postForUpdate.category, tag: postForUpdate.tag, tripRoute: tripRoute, createAt: postForUpdate.createAt, updateAt: postForUpdate.updateAt)
            
            try await updatePost()
            
            posts.sort(by: {$0.createAt > $1.createAt})
        } catch {
            print("Fail to add content: \(error)")
        }
    }
    
    func updatePost() async throws { // 업데이트된 DB로부터 게시물 불러오기 현재는 최신순으로 해놨는데 나중에 정렬 기준을 받아서 그에 맞춰서도 가능
        do {
            postsForDB = try await DB.from("POST")
                .select("""
                        id, title, content, write_user ,image, category, created_at, updated_at, tag,
                        trip_route(id, title, tag, city, writeUser:write_user(
                        id,
                        nickname,
                        profile_image
                        )
                        , start_date, end_date)
                        """)
                .execute().value
            postsForDB = postsForDB.sorted { $0.id > $1.id }
            
            posts = []
            for post in postsForDB {
                let userInfo = try await getUserInfo(userID: post.author)
                let images = try await storageStore.getImages(pathes: post.image)
                
                posts.append(PostUserVer(id: post.id, title: post.title, text: post.text, author: userInfo!, image: images, category: post.category, tag: post.tag, tripRoute: post.tripRoute, createAt: post.createAt, updateAt: post.updateAt))
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
    
    // 게시물 댓글 생성
    func insertPostComment(comment: InsertPostComment) async {
        do {
            try await DB
                .from("POST_COMMENT")
                .insert(comment)
                .select("id, write_user(id, nickname, profile_image), comment, created_at")
                .single()
                .execute()
                .value
        } catch {
            print("POST INSERT ERROR\n",error)
        }
    }
    
    // 게시물 댓글 리스트 불러오기
    @MainActor
    func getPostCommentList(postId: Int) async -> [PostComment]? {
        do {
            let postCommentList: [PostComment] = try await DB
                .from("POST_COMMENT")
                .select("id, write_user(id, nickname, profile_image), comment, created_at")
                .eq("post", value: postId)
                .order("created_at")
                .execute()
                .value
            return postCommentList
        } catch {
            print("POST GET LIST ERROR\n",error)
        }
        return nil
    }
    
    func getUserPost() async throws {
        do {
            let postsDB: [Post] = try await DB
                .from("POST")
                .select("""
                        id, title, content, write_user ,image, category, created_at, updated_at, tag,
                        trip_route(id, title, tag, city, writeUser:write_user(
                        id,
                        nickname,
                        profile_image
                        )
                        , start_date, end_date)
                        """)
                .eq("write_user", value: UserStore.shared.user.id)
                .execute()
                .value
            
            myPosts = []
            for post in postsDB {
                let userInfo = try await getUserInfo(userID: post.author)
                let images = try await storageStore.getImages(pathes: post.image)
                
                myPosts.append(PostUserVer(id: post.id, title: post.title, text: post.text, author: userInfo!, image: images, category: post.category, tag: post.tag, tripRoute: post.tripRoute, createAt: post.createAt, updateAt: post.updateAt))
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
    
    func getCategoryName(categoryNumber: Int) -> String {
        switch categoryNumber {
        case 1:
            return "질문"
        case 2:
            return "동행찾기"
        case 3:
            return "여행후기"
        case 4:
            return "맛집추천"
        default:
            return "기타"
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
