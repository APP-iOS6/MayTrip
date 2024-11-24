//
//  CommunityRecentSearchView.swift
//  MayTrip
//
//  Created by 강승우 on 11/24/24.
//

import SwiftUI

struct CommunityRecentSearchView: View {
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @Binding var searchText: String
    @Binding var searchList: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom) {
                Text("최근 검색어")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Spacer()
                
                Button {
                    searchList.removeAll()
                    UserDefaults.standard.set(searchList, forKey: "communitySearchList")
                } label: {
                    Text("모두 지우기")
                        .font(.system(size: 12))
                        .padding(.trailing)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(searchList, id: \.self) { searchText in
                        HStack(spacing: 15) {
                            Button {
                                communityStore.searchPost(searchText)
                                self.searchText = searchText
                                searchList = searchList.filter { $0 != searchText }
                                searchList.insert(searchText, at: 0)
                            } label: {
                                Text(searchText)
                            }
                            
                            Button {
                                searchList = searchList.filter { $0 != searchText }
                                UserDefaults.standard.set(searchList, forKey: "communitySearchList")
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                        .padding(10)
                        .padding(.horizontal, 5)
                        .foregroundStyle(Color("accentColor"))
                        .background {
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .foregroundStyle(Color("accentColor").opacity(0.2))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
        .padding(.top, 10)
    }
}
