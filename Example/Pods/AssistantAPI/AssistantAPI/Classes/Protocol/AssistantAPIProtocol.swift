//
//  AssistantAPIProtocol.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation
import RxSwift

public protocol AssistantProtocol {
    /**
     Register deveice return token.
     AssistantAPI will store those token information for futher request
     */
    static func registerDevice(isDevMode: Bool,
                        registrationData: String,
                        deviceCert: String,
                        signature: String,
                        isFromDevice: Bool) -> Single<AppToken>
    
    /**
     send push message to server to get messageID - using messageID to get VA Response
     */
    static func pushMessage(message: String, vaAgenId: String, nlpFeature: [String]) -> Single<String>
    /**
     get VAResponse by messageID
     */
    static func getVAResponse(by messageId: String) -> Single<VAResponse>
}
