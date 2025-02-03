//
//  AuthUser.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

struct AuthResponse: Codable {
    let access_token: String
    let token_type: String
}

struct EmptyResponse: Codable {}
