//
//  TripRouteView.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

struct TripRouteView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    TopContentsView()
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        Section(header:
                                    NavigationLink {
                            SearchView()
                        } label: {
                            HStack {
                                Text("어디로 떠나시나요?")
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                            .foregroundStyle(Color(uiColor: .gray))
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .padding()
                            .background {
                                Rectangle()
                                    .cornerRadius(10, corners: [.topLeft, .topRight])
                                    .foregroundColor(.white)
                            }
                        ) {
                            VStack {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(0..<3) { index in
                                            MyTripCardView()
                                        }
                                    }
                                }
                                .padding(.leading)
                                .scrollIndicators(.hidden)
                                
                                ForEach(0..<3) { index in
                                    RecommendRouteView()
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
                .padding(.vertical)
                
                VStack(alignment: .trailing) {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Spacer()
                        
                        NavigationLink {
                            EnterBasicInformationView()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15, height:  15)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(width: 40, height: 40)
                                .background {
                                    Circle()
                                        .foregroundStyle(Color(uiColor: .darkGray))
                                }
                                .padding()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TripRouteView()
}
