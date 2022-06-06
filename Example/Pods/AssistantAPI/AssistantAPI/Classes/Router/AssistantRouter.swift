//
//  AssistantRouter.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation

import Alamofire

enum AssistantRouter: URLRequestConvertible {
    
    case registerDevice(params: [String: Any])
    case pushMessage(deviceId: String, params: [String: Any])
    case getVAResponse(messageId: String, deviceId: String)
    
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkAdapter.shared.environment.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        if let token = NetworkAdapter.shared.appToken?.accessToken {
            urlRequest.setValue(token, forHTTPHeaderField: Constants.HttpHeaderField.token.rawValue)
        }
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    private var method: HTTPMethod {
        switch self {
        case .registerDevice:
            return .post
        case .pushMessage:
            return .post
        case .getVAResponse:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .registerDevice:
            return "/api/v1/va_gateways/devices/register"
        case .pushMessage(let deviceId, _):
            return "/api/v1/va_gateways/nlp_dialog/device/\(deviceId)/messages"
        case .getVAResponse(let messageId, let deviceId):
            return "api/v1/va_gateways/nlp_dialog/device/\(deviceId)/messages/\(messageId)/nlp_response"
            
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .registerDevice(let params):
            return params
        case .pushMessage(_, let params):
            return params
        case .getVAResponse:
            return nil
        }
    }
}
