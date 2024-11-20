//
//  SearchView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var tripRouteStore: TripRouteStore
    @State var  searchText: String = ""
    @FocusState var focused: Bool
    @State private var searchList: [String] = []
    
    var body: some View {
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
                        .onChange(of: searchText) { oldValue, newValue in
                        }
                        .onSubmit {
                            Task {
                                guard searchText != "" else { return }
                                
                                tripRouteStore.searchTripRoute(searchText)
                                
                                if !searchList.contains(searchText) {
                                    searchList.insert(searchText, at: 0)
                                }
                                UserDefaults.standard.set(searchList, forKey: "searchList")
                                
                                searchText = ""
                                focused = true
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
                .padding(10)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                }
            }
            .padding(.horizontal)
            
            RecentlySearchListView(tripRouteStore: tripRouteStore, searchList: $searchList)
            
            SearchRootView(tripRouteStore: tripRouteStore)
        }
        .onAppear {
            searchList = UserDefaults.standard.array(forKey: "searchList") as? [String] ?? []
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarBackButtonHidden()
    }
}
