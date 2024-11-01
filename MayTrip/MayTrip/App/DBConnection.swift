//
//  DBConnection.swift
//  MayTrip
//
//  Created by 권희철 on 11/1/24.
//

import Supabase
import Foundation

//Supabase DB 연결 - supabaseInfo.plist에 프로젝트url과 api key가 필요함
final class DBConnection{
    var client: SupabaseClient?
    
    init() {
        do{
            self.client = try connect()
        }catch let error{
            print("DB Connection Error: \(error.localizedDescription)")
        }
    }
    
    func connect() throws-> SupabaseClient?{
        guard let url = Bundle.main.url(forResource: "supabaseInfo", withExtension: "plist") else { return nil }
        guard let dictionary = NSDictionary(contentsOf: url) else { return nil }
        
        guard let supabaseURL = dictionary["url"] as? String else {return nil}
        guard let supabaseKey = dictionary["api_key"] as? String else {return nil}
        guard let url = URL(string: supabaseURL) else{ return nil}
        
        
        return SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }
}


