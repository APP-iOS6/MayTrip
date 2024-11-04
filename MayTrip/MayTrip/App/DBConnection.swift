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
    static let shared = DBConnection().getDB
    
    private var client: SupabaseClient?
    
    private var getDB: SupabaseClient{
        if let client = client{
            return client
        }else{
            fatalError("DB Connection Error")
        }
    }
    
    private init() {
        do{
            self.client = try connect()
        }catch let error{
            print("DB Connection Error: \(error.localizedDescription)")
        }
    }
    
    private func connect() throws-> SupabaseClient?{
        guard let url = Bundle.main.url(forResource: "supabaseInfo", withExtension: "plist") else { return nil }
        guard let dictionary = NSDictionary(contentsOf: url) else { return nil }
        
        guard let supabaseURL = dictionary["url"] as? String else {return nil}
        guard let supabaseKey = dictionary["api_key"] as? String else {return nil}
        guard let url = URL(string: supabaseURL) else{ return nil}
        
        print(supabaseURL)
        print(supabaseKey)
        return SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }
    
}


