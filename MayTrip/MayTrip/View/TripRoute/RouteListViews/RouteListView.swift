//
//  RouteListView.swift
//  MayTrip
//
//  Created by 이소영 on 11/11/24.
//

import SwiftUI

struct RouteListView: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let tripRoutes: [TripRouteSimple]
    
    var body: some View {
        NavigationStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height:  15)
                        .foregroundStyle(.black)
                }
                Spacer()
                
                Text("\(title)")
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Divider()
            
            ScrollView {
                ForEach(tripRoutes) { tripRoute in
                    RouteListCellView(route: tripRoute)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
