//
//  SearchView.swift
//  MayTrip
//
//  Created by 이소영 on 11/4/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @State var  searchText: String = ""
    @FocusState var focused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:  15)
                }
                .padding(.trailing, 5)
                
                HStack {
                    TextField("어디로 떠나시나요?", text: $searchText)
                        .onChange(of: searchText) { oldValue, newValue in
                            
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
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 1)
                }
            }
            
            RecentlySearchListView()
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SearchView()
}
