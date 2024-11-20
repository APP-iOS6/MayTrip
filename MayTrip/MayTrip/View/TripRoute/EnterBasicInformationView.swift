//
//  EnterBasicInformationView.swift
//  MayTrip
//
//  Created by 이소영 on 11/3/24.
//
import SwiftUI

struct EnterBasicInformationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    
    private let dateStore = DateStore.shared
    @State var title: String = ""
    @State var isCalendarShow: Bool = false
    @State var tag: String = ""
    @FocusState var focused: Bool
    var tripRoute: TripRoute?
    
    private var tags: [String] {
        var tags = tag.components(separatedBy: "#").filter{ $0 != "" }
        for i in 0..<tags.count {
            tags[i] = tags[i].components(separatedBy: "#").joined().trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return tags
    }
    
    var dateString: String {
        if let start = dateStore.startDate, let end = dateStore.endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yy.MM.dd"
            
            let startString = formatter.string(from: start)
            let endString = formatter.string(from: end)
            
            return "\(startString) - \(endString)"
        } else {
            return "여행 기간을 입력해주세요"
        }
    }
    
    private var isCompleteDateSetting: Bool {
        dateStore.startDate != nil && dateStore.endDate != nil
    }
    
    private var isEditedDateSetting: Bool {
        dateStore.startDate == nil || dateStore.endDate == nil || !isCompleteDateSetting
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // header
                    HStack {
                        Button {
                            dateStore.initDate()
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
                            navigationManager.push(.placeAdd(title, tags, tripRoute))
                        } label: {
                            Text("다음")
                                .padding(8)
                        }
                        .padding(.horizontal, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(dateStore.endDate == nil || !isCompleteDateSetting || title.count == 0 ? Color.gray : Color("accentColor"))
                        }
                        .foregroundStyle(.white)
                        .disabled(dateStore.endDate == nil || !isCompleteDateSetting || title.count == 0)
                    }
                    .frame(height: 20)
                    .padding(.bottom, 10)
                    
                    Divider()
                    
                    HStack {
                        TextField("제목을 입력해주세요", text: $title)
                            .focused($focused)
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            isCalendarShow = true
                        } label: {
                            Image(systemName: "calendar")
                            Text("\(dateString)")
                        }
                        .foregroundStyle(Color(uiColor: .lightGray))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    HStack {
                        TextField("#을 이용해 태그를 입력해보세요", text: $tag, axis: .vertical)
                            .keyboardType(.twitter)
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
                CalendarView(isShowing: $isCalendarShow)
                    .padding()
            }
        }
        .animation(.default, value: isCalendarShow)
        .navigationBarBackButtonHidden()
        .onChange(of: isEditedDateSetting) { oldValue, newValue in
            isCalendarShow = isEditedDateSetting
        }
        .onAppear {
            if let tripRoute = tripRoute {
                self.title = tripRoute.title
                self.tag = tripRoute.tag.map{ "# \($0)" }.joined(separator: " ")
            }
        }
    }
}

#Preview {
    EnterBasicInformationView()
}
