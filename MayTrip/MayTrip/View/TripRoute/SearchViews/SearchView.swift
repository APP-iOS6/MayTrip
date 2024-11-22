//
//  SearchView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var tripRouteStore: TripRouteStore
    @State var  searchText: String = ""
    @FocusState var focused: Bool
    @State private var searchList: [String] = []
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        tripRouteStore.resetSearchTripRoute()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height:  15)
                            .foregroundStyle(.black)
                    }
                    .padding(.trailing, 5)
                    
                    HStack {
                        TextField("어디로 떠나시나요?", text: $searchText)
                            .onSubmit {
                                Task {
                                    guard searchText != "" else { return }
                                    
                                    //tripRouteStore.searchTripRoute(searchText)
                                    print(searchText)
                                    tripRouteStore.filteredTripRoutes = await tripRouteStore.getByKeyword(keyword: searchText)
                                    
                                    if !searchList.contains(searchText) {
                                        searchList.insert(searchText, at: 0)
                                    }
                                    UserDefaults.standard.set(searchList, forKey: "searchList")
                                    
                                    searchText = ""
                                    focused = false
                                }
                            }
                            .keyboardType(.default)
                            .focused($focused)
                        
                        Button {
                            searchText = ""
                            focused = false
                        } label: {
                            VStack {
                                if searchText.count > 0 {
                                    Image(systemName: "xmark.circle.fill")
                                } else {
                                    Image(systemName: "magnifyingglass")
                                }
                            }
                            .foregroundStyle(Color(uiColor: .gray))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.gray, lineWidth: 1)
                    }
                }
                .padding(.horizontal)
                
                if searchList.count > 0 {
                    RecentlySearchListView(tripRouteStore: tripRouteStore, searchList: $searchList)
                    
                }
                
                SearchRootView(tripRouteStore: tripRouteStore)
            }
            
            if tripRouteStore.filteredTripRoutes.count == 0 {
                Text("검색 결과가 없습니다")
                    .foregroundStyle(.gray)
            }
        }
        .onAppear {
            tripRouteStore.resetSearchTripRoute()
            
            searchList = UserDefaults.standard.array(forKey: "searchList") as? [String] ?? []
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarBackButtonHidden()
    }
}
