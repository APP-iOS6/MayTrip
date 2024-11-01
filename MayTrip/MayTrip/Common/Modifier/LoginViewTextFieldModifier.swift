//
//  LoginViewTextFieldModifier.swift
//  MayTrip
//
//  Created by 강승우 on 11/1/24.
//

import SwiftUI

func CreateLoginViewTextField(text: Binding<String>, symbolName: String, placeholder: String, width: CGFloat, height: CGFloat, isSecure: Bool) -> some View {
    ZStack {
        if isSecure {
            SecureField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
        }
        else {
            TextField("", text: text)
                .padding(.horizontal, 10)
                .padding(.vertical, 15)
                .frame(width: width, height: height)
                .keyboardType(.emailAddress)
        }
        
        RoundedRectangle(cornerRadius: 5)
            .stroke(.gray.opacity(0.7), style: .init(lineWidth: 1))
            .frame(width: width, height: height)
        
        if text.wrappedValue.isEmpty {
            HStack {
                HStack {
                    Image(systemName: symbolName)
                    Text(placeholder)
                }
                Spacer()
            }
            .foregroundStyle(.gray.opacity(0.7))
            .frame(width: width - 20, height: height)
        }
    }
}
