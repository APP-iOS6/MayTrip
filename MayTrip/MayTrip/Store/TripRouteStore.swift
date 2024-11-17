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
    
    //키워드로 트립루트 검색 - 제목, 태그, 시티, 장소 이름 - 희철
    func getTripRouteListWithKeyword(keyword: String) async{
        do{
            let tripRouteList: [TripRouteSimple] = try await db
                .from("trip_route_storage_count")
                .select("*")
                .or("title.like.%\(keyword)%, tag.cs.{\(keyword)}, city.cs.{\(keyword)}, place_name.like.%\(keyword)%")
                .execute()
                .value
            
            list = tripRouteList
            
            print("----------------------------------")
            tripRouteList.forEach { TripRouteSimple in
                print(TripRouteSimple)
            }
        }catch{
            print(error)
        }
    }
    
    //유저 필터링 트립 루트 리스트 보관함: 내가 만든 여행을 가져오기 위한 함수 - 희철
    func getTripRouteListWithUser(userId: Int) async{
        do{
            let tripRouteList: [TripRouteSimple] = try await db
                .from("trip_route_storage_count")
                .select("*")
                .eq("write_user", value: userId)
                .execute()
                .value
            
            print("----------------------------------")
            tripRouteList.forEach{tripRouteSimple in
                print(tripRouteSimple)
            }
        }catch{
            print(error)
        }
    }
    
    //유저가 보관함에 넣은 트립 루트 리스트 - 희철
    func getStorageTripRouteList(userId: Int) async{
        do{
            let tripRouteList: [StorageTripRoute] = try await db
                .from("trip_route_storage")
                .select("id, title, write_user, tag, city")
                .eq("user_id", value: userId)
                .execute()
                .value
            
            print("----------------------------------")
            tripRouteList.forEach{tripRouteSimple in
                print(tripRouteSimple)
            }
        }catch{
            print(error)
        }
    }
    //트립 루트 상세 정보 가져오기 - 희철
    func getTripRoute(tripId: Int) async{
        do{
            let tripRoute: TripRoute = try await db
                .from("trip_route_detail")
                .select("""
                        id, title, tag, city, start_date, end_date, storage_count,
                        write_user:USER!write_user(id, nickname, profile_image, exp),
                        places:placegetter(*)
                        """)
                .eq("id", value: tripId)
                .single()
                .execute()
                .value
            print(tripRoute)
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
