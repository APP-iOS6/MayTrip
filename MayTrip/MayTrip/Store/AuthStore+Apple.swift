//
//  AuthStore+Apple.swift
//  MayTrip
//
//  Created by 강승우 on 11/14/24.
//
import SwiftUI
import Supabase

extension AuthStore {
    func appleLogin(idToken: String, nonce: String) async throws {
        do {
            let session = try await DB.auth.signInWithIdToken(credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
            await self.successLogin(email: session.user.email!, provider: "apple")
        } catch {
            print(error)
        }
    }
}
