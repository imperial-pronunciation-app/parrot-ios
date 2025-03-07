//
//  AuthServiceProtocol.swift
//  ParrotIos
//
//  Created by et422 on 11/02/2025.
//

import Foundation

protocol AuthServiceProtocol {

    func login(email: String, password: String) async throws

    func logout() async throws

    func register(email: String, displayName: String, password: String) async throws

    func updateDetails(name: String, email: String, language: Int) async throws

    func saveTokens(accessToken: String) throws

    func getAccessToken() -> String?

    var userDetails: UserDetails? { get }
}
