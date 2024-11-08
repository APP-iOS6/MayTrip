//
//  TripRouteStore.swift
//  MayTrip
//
//  Created by 권희철 on 11/5/24.
//
import Foundation
import Observation


@Observable
class TripRouteStore{
    let db = DBConnection.shared
    var list: [TripRouteSimple] = []
    var tripRoute: [TripRoute] = []
    
    static let shared = TripRouteStore()
    
    //트립 루트 저장용
    var title: String = ""
    var tag: [String] = []
    var city: [String] = []
    var startDate: String = ""
    var endDate: String? = nil
    
    //장소 저장 테스트용
//    var places: [PlacePost] = [
//        PlacePost(name: "테스트장소1", tripDate: .now, ordered: 1, coordinates: [34.99648581414221, 135.78456033453412]),
//        PlacePost(name: "테스트장소2", tripDate: .now, ordered: 2, coordinates: [34.99648581414221, 135.78456033453412]),
//        PlacePost(name: "테스트장소3", tripDate: .now, ordered: 3, coordinates: [34.99648581414221, 135.78456033453412]),
//        
//    ]
    var places: [PlacePost] = []
    
    //여행 루트 리스트 가져오는 함수
    func getTripRouteList() async throws-> Void{
        do{
            list = try await db
                .from("TRIP_ROUTE")
                .select("id, title, tag, city, start_date, end_date")
                .execute()
                .value
        }catch{
            print(error)
        }
    }
    
    //여행 루트 상세 정보 가져오는 함수
    func getTripRoute(id: Int) async throws -> Void{
        do{
            tripRoute = try await db
                .from("TRIP_ROUTE")
                .select(
                    """
                    *,
                    writeUser:write_user(
                     id,
                     nickname,
                     profile_image
                    ),
                    place:PLACE(
                    *
                    )
                    """
                )
                .eq("id", value: id)
                .execute()
                .value
        }catch{
            print(error)
        }
    }
    
    //여행 루트 등록하는 함수
    func addTripRoute(userId: Int) async throws -> Void{
        if title.isEmpty || city.isEmpty || startDate.isEmpty || places.isEmpty{
            print("유효성 검사 실패")
            return
        }
        let tripRoute = TripRoutePost(title: title, city: city, writeUser: userId, startDate: startDate, endDate: endDate)
        
        do{
            let routeId: [String:Int] = try await db
                .from("TRIP_ROUTE")
                .insert(tripRoute)
                .select("id")
                .single()
                .execute()
                .value
            //print (routeId)
            try await addPlace(routeId: routeId["id"]!)
        }catch{
            print(error)
        }
    }
    
    //여행 루트 장소 등록하는 함수
    private func addPlace(routeId: Int) async throws -> Void{
        for i in 0 ..< places.count{
            places[i].tripRoute = routeId
        }
        print(places)
        do{
            try await db
                .from("PLACE")
                .insert(places)
                .execute()
        }catch{
            try await db
                .from("TRIP_ROUTE")
                .delete()
                .eq("id", value: routeId)
                .execute()
            print("place insert error: \(error)")
        }
    }
    
    func resetDatas() {
        title = ""
        tag = []
        city = []
        startDate = ""
        endDate = nil
        places = []
    }
}
