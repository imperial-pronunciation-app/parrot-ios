//
//  AuthUser.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct EmptyResponse: Codable {}
