//
//  Destination.swift
//  MayTrip
//
//  Created by 강승우 on 11/13/24.
//

import Foundation

enum Destination: Hashable {
    case chatRoom(ChatRoom, [ChatLog], User)
}
