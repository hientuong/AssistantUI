//
//  RegisterResponseModel.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation


// MARK: - RegisterResponseModel
public struct RegisterResponseModel: Codable {
    public let message: String
    public let errorCode: String
    public let response: RegisterResponse

    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case response = "data"
    }
}

// MARK: - DataClass
public struct RegisterResponse: Codable {
    public let encryptedAppToken: String
    public let encryptedKey: String
    public let appToken: AppToken

    enum CodingKeys: String, CodingKey {
        case encryptedAppToken = "encrypted_app_token"
        case encryptedKey = "encrypted_key"
        case appToken = "app_token"
    }
}

// MARK: - AppToken
public struct AppToken: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let authorizationType: String
    public let accessTokenExpiredAt: Int
    public let deviceID: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case authorizationType = "authorization_type"
        case accessTokenExpiredAt = "access_token_expired_at"
        case deviceID = "device_id"
    }
}

