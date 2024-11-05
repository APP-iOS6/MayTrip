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
    
    func getTripRouteList() async throws-> Void{
        do{
            list = try await db
                .from("TRIP_ROUTE")
            //.select()
                .select("id, title, tag, city, start_date, end_date")
                .execute()
                .value
        }catch{
            print(error)
        }
    }
    
    func getTripRoute() async throws -> Void{
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
                .eq("id", value: 2)
                .execute()
                .value
        }catch{
            print(error)
        }
    }
}
