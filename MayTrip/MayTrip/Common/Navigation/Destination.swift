//
//  Destination.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
//

import Foundation

enum Destination: Hashable {
    case enterBasicInfo(tripRoute: TripRoute?)
    case placeAdd(String, [String], TripRoute?)
    case routeDetail(TripRoute)
    case chatRoom(ChatRoom, User)
    case enterBasic
    case editPost/*(PostUserVer)*/
    case postDetail/*([PostComment]?)*/
}
