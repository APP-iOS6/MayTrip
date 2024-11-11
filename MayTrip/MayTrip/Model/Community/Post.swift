//
//  Post.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct Post { // 임시 모델 추후에 바뀔수도 있음
    let id: Int
    let title: String
    let text: String
    let author: User
    let images: [String] // 최대 5개?
    let category: String // 나중에 이넘으로 제한두기
    let tripRoute: TripRoute? // 여행 후기 작성하려면 필요한거 아닌지?
    let createAt: Date
}
