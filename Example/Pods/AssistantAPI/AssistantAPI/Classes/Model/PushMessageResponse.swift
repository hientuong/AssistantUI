//
//  PushMessageResponse.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 02/06/2022.
//

import Foundation

// MARK: - PushMessageResponse
public struct PushMessageResponse: Codable {
    public let message: String
    public let errorCode: Int
    public let data: MessageResponse
    
    var messageId: String? {
        return data.messageId
    }
    
    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data = "data"
    }
}


public struct MessageResponse: Codable {
    public let messageId: String
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
    }
}



