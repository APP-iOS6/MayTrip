//
//  SearchAddressStore.swift
//  MayTrip
//
//  Created by 최승호 on 11/1/24.
//

import Foundation
import Combine
import Observation
import MapKit

@MainActor
@Observable
final class SearchAddressStore {
    
    static let shared = SearchAddressStore()
    
    private(set) var documents: [Document] = []
    
    private init() {}
    
    func getAddresses(query: String, coordinate: CLLocationCoordinate2D?) async throws {
        let restAPIKey: String = Bundle.main.infoDictionary?["RestKey"] as! String
        let header: String = "KakaoAK \(restAPIKey)"
        let urlString: String = "https://dapi.kakao.com/v2/local/search/keyword.json"
        
        guard var url = URL(string: urlString) else { throw HTTPError.notFound }
        
        if let coordinate {
            url.append(queryItems: [URLQueryItem(name: "query", value: query), URLQueryItem(name: "x", value: "\(coordinate.longitude)"), URLQueryItem(name: "y", value: "\(coordinate.latitude)")])
        } else {
            url.append(queryItems: [URLQueryItem(name: "query", value: query)])
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.addValue(header, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw HTTPError.badRequest }
            
            if (400...599).contains(httpResponse.statusCode) {
                throw getHTTPError(httpResponse.statusCode)
            }
            
            let result = try JSONDecoder().decode(SearchedAddress.self, from: data)
            
            self.documents = result.documents
            
        } catch {
            throw error
        }
    }
    
    /**
    거리를 km, m로 변환하여 문자열로 반환하는 함수 (ex: "1.8km", "976m")
    */
    
    func getDistance(from distance: String) -> String {
        var result = ""
        
        if distance.count > 3 {
            let km = Double(distance)! / 1000
            result = String(format: "%.1f", km) + "km"
        } else if distance.count > 0 {
            let m = distance + "m"
            result = m
        }
        
        return result
    }
    
    private func getHTTPError(_ statusCode: Int) -> HTTPError {
        switch statusCode {
        case 400:
            return HTTPError.badRequest
        case 401:
            return HTTPError.unauthorized
        case 403:
            return HTTPError.forbidden
        case 404:
            return HTTPError.notFound
        case 405:
            return HTTPError.methodNotAllowed
        case 408:
            return HTTPError.requestTimeout
        case 409:
            return HTTPError.conflict
        case 410:
            return HTTPError.gone
        case 412:
            return HTTPError.preconditionFailed
        case 413:
            return HTTPError.payloadTooLarge
        case 415:
            return HTTPError.unsupportedMediaType
        case 429:
            return HTTPError.tooManyRequests
        case 500:
            return HTTPError.internalServerError
        case 501:
            return HTTPError.notImplemented
        case 502:
            return HTTPError.badGateway
        case 503:
            return HTTPError.serviceUnavailable
        case 504:
            return HTTPError.gatewayTimeout
        default:
            return HTTPError.notFound
        }
    }
}

struct SearchedAddress: Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Identifiable, Codable {
    let id: String = UUID().uuidString
    let placeName: String           // 장소명, 업체명
    let categoryName: String        // 카테고리 이름
    let categoryGroupCode: String   // 중요 카테고리만 그룹핑한 카테고리 그룹 코드
    let categoryGroupName: String   // 중요 카테고리만 그룹핑한 카테고리 그룹명
    let phone: String               // 전화번호
    let addressName: String         // 전체 지번 주소
    let roadAddressName: String     // 전체 도로명 주소
    let x: String                   // X 좌표값, 경위도인 경우 longitude (경도)
    let y: String                   // Y 좌표값, 경위도인 경우 latitude(위도)
    let placeURL: String            // 장소 상세페이지 URL
    let distance: String            // 중심좌표까지의 거리 (단, x,y 파라미터를 준 경우에만 존재) 단위 meter
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case categoryName = "category_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case phone
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x
        case y
        case placeURL = "place_url"
        case distance = "distance"
    }
}

struct Meta: Codable {
    let totalCount: Int         // 검색어에 검색된 문서 수
    let pageableCount: Int      // total_count 중 노출 가능 문서 수 (최대: 45)
    let isEnd: Bool             // 현재 페이지가 마지막 페이지인지 여부
    let sameName: SameName      // 질의어의 지역 및 키워드 분석 정보
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
        case sameName = "same_name"
    }
}

struct SameName: Codable {
    let region: [String]        // 질의어에서 인식된 지역의 리스트 (예: '중앙로 맛집' 에서 중앙로에 해당하는 지역 리스트)
    let keyword: String         // 질의어에서 지역 정보를 제외한 키워드 (예: '중앙로 맛집' 에서 '맛집')
    let selectedRegion: String  // 인식된 지역 리스트 중, 현재 검색에 사용된 지역 정보
    
    enum CodingKeys: String, CodingKey {
        case region = "region"
        case keyword = "keyword"
        case selectedRegion = "selected_region"
    }
}

enum HTTPError: String, Error {
    case badRequest             // 400
    case unauthorized           // 401
    case forbidden              // 403
    case notFound               // 404
    case methodNotAllowed       // 405
    case requestTimeout         // 408
    case conflict               // 409
    case gone                   // 410
    case preconditionFailed     // 412
    case payloadTooLarge        // 413
    case unsupportedMediaType   // 415
    case tooManyRequests        // 429
    case internalServerError    // 500
    case notImplemented         // 501
    case badGateway             // 502
    case serviceUnavailable     // 503
    case gatewayTimeout         // 504
}
