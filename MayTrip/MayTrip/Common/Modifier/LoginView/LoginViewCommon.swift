//
//  LoginViewTextFieldModifier.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

func CreateLoginViewTextField(text: Binding<String>, symbolName: String, placeholder: String, width: CGFloat, height: CGFloat, isSecure: Bool, isFocused: Bool, isEmail: Bool) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 5)
            .stroke(isFocused ? .accent : .gray.opacity(0.7), style: .init(lineWidth: 1))
            .frame(width: width, height: height)
            .padding(.horizontal, 5)
        
        if text.wrappedValue.isEmpty {
            HStack {
                HStack {
                    if !symbolName.isEmpty {
                        Image(systemName: symbolName)
                    }
                    Text(placeholder)
                }
                Spacer()
            }
            .foregroundStyle(Color(uiColor: .systemGray3))
            .frame(width: width - 20, height: height)
        }
        
        if isSecure {
            SecureField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .background(.clear)
        }
        else {
            TextField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
                .keyboardType(isEmail ? .emailAddress : .default)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .background(.clear)
        }
    }
}
