//
//  Post.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct Post: Codable { // 게시물 DB에서 불러오기용
    let id: Int
    let title: String
    let text: String
    let author: Int
    let image: [String] // 최대 5개?
    let category: Int // 나중에 이넘으로 제한두기
    let createAt: Date
    let updateAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text = "content"
        case author = "write_user"
        case image
        case category
        case createAt = "created_at"
        case updateAt = "updated_at"
    }
}

struct PostUserVer: Hashable { // 게시물에 유저의 프로필 이미지, 닉네임들을 보여주기 위해 실제로 사용할 모델
    let id: Int
    let title: String
    let text: String
    let author: User
    let image: [UIImage]
    let category: Int
    let createAt: Date
    let updateAt: Date
}

struct PostDB: Codable { // 게시물 업로드용
    let title: String
    let text: String
    let author: Int
    let image: [String]
    let category: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case text = "content"
        case author = "write_user"
        case image
        case category
    }
}

// DB에 게시글 업데이트 하기 위한 용도
struct PostForDB: Codable {
    let title: String
    let text: String
    let author: Int
    let image: [String] // 최대 5개?
    let category: Int // 나중에 이넘으로 제한두기
    let createAt: Date
    let updateAt: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case text = "content"
        case author = "write_user"
        case image
        case category
        case createAt = "created_at"
        case updateAt = "updated_at"
    }
}
