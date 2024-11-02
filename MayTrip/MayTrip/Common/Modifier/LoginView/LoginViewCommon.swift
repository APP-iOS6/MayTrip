//
//  LoginViewTextFieldModifier.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

func CreateLoginViewTextField(text: Binding<String>, symbolName: String, placeholder: String, width: CGFloat, height: CGFloat, isSecure: Bool, isFocused: Bool) -> some View {
    ZStack {
        if isSecure {
            SecureField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
        }
        else {
            TextField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
        }
        
        RoundedRectangle(cornerRadius: 5)
            .stroke(isFocused ? .accent : .gray.opacity(0.7), style: .init(lineWidth: 1))
            .frame(width: width, height: height)
        
        if text.wrappedValue.isEmpty {
            HStack {
                HStack {
                    if symbolName != "" {
                        Image(systemName: symbolName)
                    }
                    Text(placeholder)
                }
                Spacer()
            }
            .foregroundStyle(Color(uiColor: .systemGray3))
            .frame(width: width - 20, height: height)
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
