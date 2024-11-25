//
//  CommunitySearchView.swift
//  MayTrip
//
//  Created by 강승우 on 11/24/24.
//

import SwiftUI

struct CommunitySearchView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CommunityStore.self) var communityStore: CommunityStore
    @State var searchText: String = ""
    @State private var searchList: [String] = []
    @FocusState var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    communityStore.resetSearchPost()
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
                    TextField("검색어를 입려햐주세요", text: $searchText)
                        .onSubmit {
                            Task {
                                guard searchText != "" else { return }
                                
                                communityStore.searchPost(searchText)
                                searchList = searchList.filter {$0 != searchText}
                                searchList.insert(searchText, at: 0)
                                UserDefaults.standard.set(searchList, forKey: "communitySearchList")
                                focused = false
                            }
                        }
                        .keyboardType(.default)
                        .focused($focused)
                    
                    Button {
                        searchText = ""
                        communityStore.isSearching = false
                        focused = true
                    } label: {
                        VStack {
                            if searchText.count > 0 || communityStore.isSearching {
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
            
            if searchList.count > 0 && searchText.count == 0 && !communityStore.isSearching {
                CommunityRecentSearchView(searchText: $searchText, searchList: $searchList)
            }
            
            if communityStore.isSearching {
                CommunitySearchResultView()
                    .padding(.top, 20)
            } else {
                Spacer()
            }
        }
        .onAppear {
            communityStore.resetSearchPost()
            searchList = UserDefaults.standard.array(forKey: "communitySearchList") as? [String] ?? []
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarBackButtonHidden()
    }
}
