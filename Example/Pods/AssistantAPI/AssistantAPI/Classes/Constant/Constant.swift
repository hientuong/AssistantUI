//
//  Constant.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation
struct Constants {
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case token = "token"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
}
