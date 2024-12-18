//
//  RecentlySearchListView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//


import SwiftUI

struct RecentlySearchListView: View {
    @EnvironmentObject var tripRouteStore: TripRouteStore
    @Binding var searchList: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("최근 검색어")
                .font(.title)
                .bold()
                .padding(.horizontal)
                .padding(.top, 10)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(searchList, id: \.self) { searchText in
                        HStack(spacing: 15) {
                            Button {
                                Task{
                                    tripRouteStore.filteredTripRoutes =  await tripRouteStore.getByKeyword(keyword: searchText)
                                }
                            } label: {
                                Text(searchText)
                            }
                            
                            Button {
                                searchList.removeAll(where: { $0.contains(searchText) })
                                UserDefaults.standard.set(searchList, forKey: "searchList")
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
