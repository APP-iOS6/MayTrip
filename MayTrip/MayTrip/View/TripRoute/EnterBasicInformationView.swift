//
//  EnterBasicInformationView.swift
//  MayTrip
//
//  Created by 이소영 on 11/3/24.
//
import SwiftUI

struct EnterBasicInformationView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var isCalendarShow: Bool = false
    @State var tag: String = ""
    @FocusState var focused: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)

                        }
                        .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("다음")
                                .padding(8)
                        }
                        .padding(.horizontal, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.tint)
                        }
                        .foregroundStyle(.white)
                    }
                    .frame(height: 20)
                    .padding(.bottom, 10)
                    
                    Divider()
                    
                    HStack {
                        TextField("제목", text: $title)
                            .focused($focused)
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            isCalendarShow = true
                        } label: {
                            Image(systemName: "calendar")
                            Text("여행 기간을 입력해주세요")
                        }
                        .foregroundStyle(Color(uiColor: .lightGray))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    
                    HStack {
                        TextField("#을 이용해 태그를 입력해보세요", text: $tag, axis: .vertical)
                            .focused($focused)
                    }
                    .padding(.vertical, 10)
                }
                .padding()
            }
            .onTapGesture {
                isCalendarShow = false
                focused = false
            }
            
            if isCalendarShow {
                CalendarView()
                    .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EnterBasicInformationView()
}
