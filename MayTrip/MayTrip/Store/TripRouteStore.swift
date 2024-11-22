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
    @Published var filteredTripRoutes: [TripRouteSimple] = []
    
    //트립 루트 저장용
    @Published var title: String = ""
    @Published var tag: [String] = []
    @Published var city: [String] = []
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var places: [PlacePost] = []
    
    var listStartIndex: Int = 0
    var listEndIndex: Int = 9
    var lastTripRouteID: Int = 0
    var isExistRoute: Bool = true
    
    //여행 루트 리스트 가져오는 함수
    @MainActor
    func getTripRouteList() async throws-> Void{
        do {
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
        } catch {
            print(error)
        }
    }
    
    // 트립루트 리스트 fetch
    @MainActor
    func getList() async -> [TripRouteSimple]{
        let userId = userStore.user.id
        do {
            let tripRouteList: [TripRouteSimple] = try await db
                .from("trip_route_with_storage_count")
                .select("id, title, city, tag, start_date, end_date, user_id, count:count, created_at")
                .or("user_id.eq.\(userId), user_id.is.null")
                .order("created_at", ascending: false)
                .range(from: listStartIndex, to: listEndIndex)
                .execute()
                .value
            
            listStartIndex += 10
            listEndIndex += 10
            lastTripRouteID = tripRouteList.last?.id ?? 0
            
            if tripRouteList.count < 10{
                isExistRoute.toggle()
            }
            return tripRouteList
        } catch {
            print(error)
            return []
        }
    }
    
    //여행 루트 리스트 keyword를 통해 가져오기 - 희철
    @MainActor
    func getByKeyword(keyword: String) async -> [TripRouteSimple] {
        print(keyword)
        let userId = userStore.user.id
        do {
            let tripRouteList: [TripRouteSimple] = try await db
                .from("trip_route_with_storage_count")
                .select("id, title, city, tag, start_date, end_date, user_id, count:count, created_at")
                .or("user_id.eq.\(userId), user_id.is.null")
                .or("title.like.%\(keyword)%, tag.cs.{\(keyword)}, city.cs.{\(keyword)}, place_name.like.%\(keyword)%")
            //                .or("title.like.%\(keyword)%, 'array_to_string(tag, ',')'.like.%\(keyword)%, 'array_to_string(city, ',')'.like.%\(keyword)%, place_name.like.%\(keyword)%")
                .order("created_at", ascending: false)
                .execute()
                .value
            
            return tripRouteList
        } catch {
            print(error)
            return []
        }
    }
    
    //ROUTE_STORAGE에 데이터 넣기
    func insertStorageByRouteId(routeId: Int) async -> Bool{
        let userId: Int = UserStore.shared.user.id
        let storage = ["user_id": userId, "route_id": routeId]
        do{
            try await db
                .from("ROUTE_STORAGE")
                .insert(storage)
                .execute()
            
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    //ROUTE_STORAGE에 데이터 제거
    func deleteStorageByRouteId(routeId: Int) async -> Bool{
        let userId: Int = UserStore.shared.user.id
        do{
            try await db
                .from("ROUTE_STORAGE")
                .delete()
                .eq("user_id", value: userId)
                .eq("route_id", value: routeId)
                .execute()
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    //여행 루트 상세 정보 가져오는 함수
    @MainActor
    func getTripRoute(id: Int) async throws -> Void {
        do {
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
        } catch {
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
                        id, title, tag, city, write_user
                        ,start_date, end_date, created_at
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
        let tripRoute = TripRoutePost(title: title, tag: tag, city: city, writeUser: userId, startDate: startDate, endDate: endDate)
        
        do {
            let routeId: [String:Int] = try await db
                .from("TRIP_ROUTE")
                .insert(tripRoute)
                .select("id")
                .single()
                .execute()
                .value
            //print (routeId)
            try await addPlace(routeId: routeId["id"]!)
        } catch {
            print(error)
        }
    }
    
    //여행 루트 장소 등록하는 함수
    @MainActor
    private func addPlace(routeId: Int) async throws -> Void{
        for i in 0 ..< places.count{
            places[i].tripRoute = routeId
        }
        do {
            try await db
                .from("PLACE")
                .insert(places)
                .execute()
        } catch {
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
    
    // 해당 루트 업데이트 하는 함수
    func updateTripRoute(routeId: Int, userId: Int) async throws -> Void{
        if title.isEmpty || city.isEmpty || startDate.isEmpty || places.isEmpty{
            print("업데이트: 유효성 검사 실패")
            return
        }
        let tripRoute = TripRoutePost(title: title, tag: tag, city: city, writeUser: userId, startDate: startDate, endDate: endDate)
        
        do {
            try await db
                .from("TRIP_ROUTE")
                .update(tripRoute)
                .eq("id", value: routeId)
                .execute()
            
            try await replacePlaces(routeId: routeId)
        } catch {
            print("Route Update Error: \(error)")
        }
    }
    
    // 해당 루트의 장소들 업데이트 하는 함수
    @MainActor
    func replacePlaces(routeId: Int) async throws -> Void{
        for i in 0..<places.count {
            places[i].tripRoute = routeId
        }
        
        do {
            try await db
                .from("PLACE")
                .delete()
                .eq("trip_route", value: routeId)
                .execute()
            
            try await addPlace(routeId: routeId)
        } catch {
            print("Places Upsert Error: \(error)")
        }
    }
    
    func searchTripRoute(_ search: String) {
        filteredTripRoutes = list.filter {
            if let tags = $0.tag {
                tags.contains(search) || $0.city.contains(search) || $0.title.contains(search)
            } else {
                $0.city.contains(search) || $0.title.contains(search)
            }
        }
    }
    
    func resetSearchTripRoute() {
        filteredTripRoutes = []
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
