//
//  PlaceStore.swift
//  MayTrip
//
//  Created by 최승호 on 11/11/24.
//

import Foundation
import MapKit

final class PlaceStore {
//    static let shared = PlaceStore()
    
    init() {
        print("hello placeStore!!")
    }
    
    // placePost의 위도,경도값 가져오기
    static func getCoordinate(for place: PlacePost) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: place.coordinates[0], longitude: place.coordinates[1])
    }
    
    // [plcePost]의 위도,경도값들 가져오기
    static func getCoordinates(for place: [PlacePost]) -> [CLLocationCoordinate2D] {
        place.map{ CLLocationCoordinate2D(latitude: $0.coordinates[0], longitude: $0.coordinates[1]) }
    }
    
    // 장소 전체에서 해당 날짜의 [placePost] 필터링하기
    static func getPlace(for date: Date, places: [PlacePost]) -> [PlacePost]? {
        places.filter{ $0.tripDate == date }
    }
    
    
    static func isEmpty(for places: [[PlacePost]]) -> Bool {
        // 값이 하나라도 있는지 검사.
        let result = places.flatMap{ $0 }.isEmpty
        return result
    }
    
    // index에 맞게 ordered값 재정의
    static func indexingPlace(_ places: [[PlacePost]]) -> [[PlacePost]] {
        var places = places
        
        for i in 0..<places.count {
            for j in 0..<places[i].count {
                places[i][j].ordered = j + 1
            }
        }
        
        return places
    }
    
    // categoryCode -> categoryName으로 변환
    static func getCategory(_ category: String) -> String {
        switch category {
        case "MT1":
            return "대형마트"
        case "CS2":
            return "편의점"
        case "PS3":
            return "어린이집, 유치원"
        case "SC4":
            return "학교"
        case "AC5":
            return "학원"
        case "PK6":
            return "주차장"
        case "OL7":
            return "주유소, 충전소"
        case "SW8":
            return "지하철역"
        case "BK9":
            return "은행"
        case "CT1":
            return "문화시설"
        case "AG2":
            return "중개업소"
        case "PO3":
            return "공공기관"
        case "AT4":
            return "관광명소"
        case "AD5":
            return "숙박"
        case "FD6":
            return "음식점"
        case "CE7":
            return "카페"
        case "HP8":
            return "병원"
        case "PM9":
            return "약국"
        case "ETC":
            return "기타"
        default:
            return category
        }
    }
}
