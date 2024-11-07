//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    var routeStore: DummyRouteStore = .shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    TopContentsView()
                        .padding(.bottom, 8)
                    
                    MyTripCardView()
                        .padding(.bottom, 15)
                    
                    RecommendRouteView()
                }
                .padding(.vertical)
            }
            .padding(.vertical)
            .scrollIndicators(.hidden)
            .toolbar {
                HStack(spacing: 20) {
                    Image("appLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 35)
                    
                    Spacer()
                    
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                    }
                    
                    NavigationLink {
                        EnterBasicInformationView()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 15, height:  15)
                            .foregroundStyle(Color("accentColor"))
                    }
                }
            }
        }
    }
}

import Observation

struct DummyUser: Identifiable {
    var id: Int
    var nickname: String
    var profile_image: String
    var email: String// = "test@test.com"
    var exp: Int = 0
    var created_at: Date = Date()
    var updated_at: Date?
}

struct DummyTripRoute: Identifiable {
    var id: Int
    var title: String
    var tags: [String]
    var cities: [String]
    var write_user: Int
    var start_date: Date
    var end_date: Date
    var created_at: Date = Date()
    var updated_at: Date?
}

struct DummySavedRoute: Identifiable {
    var id: Int
    var user_id: Set<Int> = []
}

let signedUser: DummyUser = DummyUser(id: 0, nickname: "프로여행러", profile_image: "person.crop.circle", email: "test@test.com")

var tripRoutes: [DummyTripRoute] = [
    DummyTripRoute(id: 0, title: "나 혼자 떠나는 강원도여행", tags: ["서핑", "바다", "여름"], cities: ["양양", "속초"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 1)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 6)) ?? .init()),
    DummyTripRoute(id: 1, title: "해산물 을왕리여행", tags: ["조개구이", "대하구이"], cities: ["을왕리"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 1)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 3)) ?? .init()),
    DummyTripRoute(id: 2, title: "먹는게 제일 조아 먹방여행", tags: ["막창", "게란후라이", "아이스크림", "딸기모찌", "전주비빔밥"], cities: ["대구", "부산", "여수", "전주"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10)) ?? .init()),
    DummyTripRoute(id: 3, title: "먹는게 제일 조아 먹방여행", tags: ["막창", "게란후라이", "아이스크림", "딸기모찌", "전주비빔밥"], cities: ["대구", "부산", "여수", "전주"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 10)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 10)) ?? .init()),
    DummyTripRoute(id: 4, title: "먹는게 제일 조아 먹방여행2", tags: ["짜장면", "짬뽕", "탕수육", "치킨"], cities: ["대구", "부산", "여수", "전주"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 10)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 12)) ?? .init()),
    DummyTripRoute(id: 5, title: "먹는게 제일 조아 먹방여행3", tags: ["떡볶이", "게란말이", "계란찜"], cities: ["대구", "부산", "여수", "전주"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 8)) ?? .init()),
    DummyTripRoute(id: 6, title: "먹는게 제일 조아 먹방여행4", tags: ["핫바", "김밥"], cities: ["대구", "부산", "여수", "전주"], write_user: 0, start_date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10)) ?? .init(), end_date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 10)) ?? .init())]

var users: [DummyUser] = [signedUser, DummyUser(id: 1, nickname: "방랑자", profile_image: "person.circle", email: "test1@test.com"), DummyUser(id: 2, nickname: "여행가자", profile_image: "person.crop.circle", email: "test@test.com"), DummyUser(id: 3, nickname: "좋아요", profile_image: "person.circle", email: "test1@test.com")]

enum Standard: String, CaseIterable {
    case savedAlot = "찜을 가장 많이 받은 여행"
    case bestSeason = "지금 계절에 가기 좋은 여헹"
}

@Observable
class DummyRouteStore {
    static let shared: DummyRouteStore = DummyRouteStore()
    
    private var savedRouteList: [DummySavedRoute] = [DummySavedRoute(id: 0, user_id: [0]), DummySavedRoute(id: 4, user_id: [0]), DummySavedRoute(id: 3, user_id: [0])]
    
    var createdRoutes: [DummyTripRoute] {
        tripRoutes.filter {
            $0.write_user == signedUser.id
        }
    }
    
    var savedRoutes: [DummyTripRoute] {
        var savedRoutes: [DummyTripRoute] = []
        var filteredRoutes: [DummySavedRoute] = []
        
        for route in savedRouteList {
            for user in route.user_id {
                if user == signedUser.id {
                    filteredRoutes.append(route)
                }
            }
        }
        
        for route in filteredRoutes {
            if let index = tripRoutes.firstIndex(where: { $0.id == route.id }) {
                savedRoutes.append(tripRoutes[index])
            }
        }
        
        return savedRoutes
    }
    
    func getRoute(_ id: Int) -> DummyTripRoute {
        tripRoutes.filter { $0.id == id }.first!
    }
    
    func createRoute(_ route: DummyTripRoute) {
        tripRoutes.append(route)
    }
    
    func saveRoute(_ route: Int) {
        let savedRoute = savedRouteList.filter {
            $0.id == route
        }.first ?? nil
        
        if var saved = savedRoute {
            saved.user_id.insert(signedUser.id)
            
            if let index = savedRouteList.firstIndex(where: { $0.id == route }) {
                savedRouteList[index] = saved
            }
        } else {
            savedRouteList.append(DummySavedRoute(id: route, user_id: [signedUser.id]))
        }
    }
    
    func deleteSavedRoute(_ route: Int) {
        if let index = savedRouteList.firstIndex(where: { $0.id == route }) {
            savedRouteList.remove(at: index)
        }
    }
    
    func convertPeriodToString(_ start: Date, end: Date) -> String {
        let dateDiff = Calendar.current.dateComponents([.year, .month, .day], from: start, to: end)
        
        var dateString = "당일치기"
        
        if case let (year?, month?, day?) = (dateDiff.year, dateDiff.month, dateDiff.day) {
            if day != 0 {
                dateString = "\(day)박 \(day + 1)일"
            }
            
            if year != 0 || month != 0 {
                dateString = "장기"
            }
        }
        
        return dateString
    }
    
    func convertMonthToSeason(_ start: Date) -> String {
        let month = Calendar.current.component(.month, from: start)
        var season: String = ""
        
        switch month {
        case 1, 2, 3, 12: season = "겨울"
        case 4, 5, 6: season = "봄"
        case 7, 8, 9: season = "여름"
        case 10, 11: season = "가을"
        default: break
        }
        
        return season
    }
    
    func isOnATrip(_ start: Date, end: Date) -> Bool {
        let date = Date()
        
        let today = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let startDay = Calendar.current.dateComponents([.year, .month, .day], from: start)
        let endDay = Calendar.current.dateComponents([.year, .month, .day], from: end)
        
        return today == startDay || today == endDay || (date > start && date < end)
    }
    
    func categorizeRoute(_ standard: Standard) -> [DummyTripRoute] {
        var categorizedRoute: [DummyTripRoute] = []
        
        switch standard {
        case .bestSeason:
            let season = convertMonthToSeason(Date())
            categorizedRoute = tripRoutes.filter {
                convertMonthToSeason($0.start_date) == season
            }
        case .savedAlot:
            let routeList: [DummySavedRoute] = savedRouteList.sorted(by: {$0.user_id.count > $1.user_id.count})
            
            for route in routeList {
                if let index = tripRoutes.firstIndex(where: { $0.id == route.id }) {
                    categorizedRoute.append(tripRoutes[index])
                }
            }
        }
        
        return categorizedRoute
    }
}

#Preview {
    TripRouteView()
}
