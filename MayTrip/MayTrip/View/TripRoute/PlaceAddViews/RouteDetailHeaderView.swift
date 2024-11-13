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
    var tripRoute: TripRoute
    let dateStore: DateStore = DateStore.shared
    
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
            .foregroundStyle(.black)
            
            Spacer()
            
            Button {
                // 보고있는 루트 편집화면으로 이동하는 로직
                navigationManager.push(.enterBasicInfo(tripRoute: tripRoute))
            } label: {
                Text("편집")
                    .padding(8)
            }
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("accentColor"))
            }
            .foregroundStyle(.white)
        }
        .frame(height: 20)
        .padding(.bottom, 10)
        .padding(.horizontal)
    }
    
    var titleView: some View {
        HStack(alignment: .bottom) {
            Text("\(tripRoute.title)")
//                .font()
                .bold()
        
            Spacer()
//            Text("작성자: \(tripRoute.writeUser.nickname)")
//                .font(.footnote)
            Button {
                
            } label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color("accentColor"))
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
