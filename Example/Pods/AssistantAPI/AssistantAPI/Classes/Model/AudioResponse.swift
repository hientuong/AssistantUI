//
//  AudioResponse.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 05/06/2022.
//

import Foundation

// MARK: - AudioResponse
public struct AudioResponse: Codable {
    public var errorCode: Int?
    public var message: String?
    public var responseData: ResponseData?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message = "message"
        case responseData = "data"
    }

    public init(errorCode: Int?, message: String?, data: ResponseData?) {
        self.errorCode = errorCode
        self.message = message
        self.responseData = data
    }
}

// MARK: - ResponseData
public struct ResponseData: Codable {
    public var paragraph: String?
    public var sentences: [String]?

    enum CodingKeys: String, CodingKey {
        case paragraph = "paragraph"
        case sentences = "sentences"
    }

    public init(paragraph: String?, sentences: [String]?) {
        self.paragraph = paragraph
        self.sentences = sentences
    }
}
