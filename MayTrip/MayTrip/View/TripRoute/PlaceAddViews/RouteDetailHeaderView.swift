//
//  RouteDetailHeaderView.swift
//  MayTrip
//
//  Created by 최승호 on 11/12/24.
//

import SwiftUI

struct RouteDetailHeaderView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    @State var isScraped: Bool = false
    var tripRoute: TripRoute
    let dateStore: DateStore = DateStore.shared
    let userStore: UserStore = UserStore.shared
    
    var isWriter: Bool {
        tripRoute.writeUser.id == userStore.user.id
    }
    
    var body: some View {
        headerView
        titleView
        cityTagsView
    }
    
    var headerView: some View {
        HStack {
            Button {
                dateStore.initDate()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.primary)
            
            Spacer()
            
            Menu {
                if isWriter {   // 루트 작성자일때 메뉴버튼
                    Button("편집하기") {
                        // TODO: 루트 편집으로 이동, 편집완료시 db에 업데이트 로직
                    }
                    
                    Button("삭제하기", role: .destructive) {
                        // TODO: 해당 루트 db에서 삭제 로직
                    }
                    
                } else {    // 조회하는 사람일때 메뉴버튼
                    Button("채팅하기") {
                        // TODO: write유저와 채팅 연결
                    }
                    
                    Button("신고하기", role: .destructive) {
                        // TODO: write유저 신고 로직
                    }
                    .foregroundStyle(.red)
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
        }
        .foregroundStyle(.primary)
        .frame(height: 20)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
    
    var titleView: some View {
        HStack(alignment: .bottom) {
            Text("\(tripRoute.title)")
                .font(.title2)
                .bold()
        
            Spacer()
            
            if !isWriter {
                Text("작성자: \(tripRoute.writeUser.nickname)")
                    .font(.footnote)
                
                Button {
                    isScraped.toggle()
                } label: {
                    Image(systemName: isScraped ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    var cityTagsView: some View {
        HStack {
            VStack {
                CityTagFlowLayout(spacing: 10) {
                    ForEach(tripRoute.city, id: \.self) { city in
                        Text("# \(city)")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundStyle(Color(UIColor.darkGray))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}
