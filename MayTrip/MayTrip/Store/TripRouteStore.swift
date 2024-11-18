//
//  TripRouteStore.swift
//  MayTrip
//
//  Created by 권희철 on 11/5/24.
//
import Foundation
import Observation


class TripRouteStore: ObservableObject {
    let db = DBConnection.shared
    let userStore = UserStore.shared
    
    @Published var list: [TripRouteSimple] = []
    @Published var tripRoute: [TripRoute] = []
    @Published var myTripRoutes: [TripRouteSimple] = []
    
    //트립 루트 저장용
    @Published var title: String = ""
    @Published var tag: [String] = []
    @Published var city: [String] = []
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    
    //장소 저장 테스트용
//    var places: [PlacePost] = [
//        PlacePost(name: "테스트장소1", tripDate: .now, ordered: 1, coordinates: [34.99648581414221, 135.78456033453412]),
//        PlacePost(name: "테스트장소2", tripDate: .now, ordered: 2, coordinates: [34.99648581414221, 135.78456033453412]),
//        PlacePost(name: "테스트장소3", tripDate: .now, ordered: 3, coordinates: [34.99648581414221, 135.78456033453412]),
//        
//    ]
    @Published var places: [PlacePost] = []
    
    //여행 루트 리스트 가져오는 함수
    @MainActor
    func getTripRouteList() async throws-> Void{
        do{
            list = try await db
                .from("TRIP_ROUTE")
                .select(
                        """
                        id, title, tag, city, writeUser:write_user(
                        id,
                        nickname,
                        profile_image
                        )
                        ,start_date, end_date
                        """
                )
                .execute()
                .value
        }catch{
            print(error)
        }
    }
    
    //여행 루트 상세 정보 가져오는 함수
    @MainActor
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
    
    // 유저가 생성한 루트만 가져오는 함수
    @MainActor
    func getCreatedByUserRoutes() async throws {
        do {
            myTripRoutes = try await db
                .from("TRIP_ROUTE")
                .select(
                        """
                        id, title, tag, city, writeUser:write_user(
                        id,
                        nickname,
                        profile_image
                        )
                        ,start_date, end_date
                        """
                )
                .eq("write_user", value: userStore.user.id)
                .order("start_date", ascending: false) // 내림차순으로 정렬
                .execute()
                .value
        } catch {
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
    
    // 해당 루트 삭제하는 함수
    func deleteTripRoute(routeId: Int) async throws -> Void{
        do {
            try await db
                .from("TRIP_ROUTE")
                .delete()
                .eq("id", value: routeId)
                .execute()
        } catch {
            print("Route Delete Error: \(error)")
        }
    }
    
    func inputDatas(title: String, tags: [String], places: [PlacePost], cities: [String], startDate: String, endDate: String) {
        self.title = title
        self.tag = tags
        self.places = places
        self.city = cities
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func resetDatas() {
        title = ""
        tag = []
        city = []
        startDate = ""
        endDate = ""
        places = []
    }
}
