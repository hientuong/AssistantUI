//
//  AssistantClient.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import RxSwift
import Alamofire

public struct AssistantClient: AssistantProtocol {
    
    static var client: BaseClient = BaseClient()
    
    public init(){}
    
    public static func registerDevice(isDevMode: Bool,
                                      registrationData: String,
                                      deviceCert: String,
                                      signature: String,
                                      isFromDevice: Bool) -> Single<AppToken> {
        let params: [String: Any] = [
            "device_cert": deviceCert,
            "is_dev_mode": isDevMode,
            "registration_data": registrationData,
            "signature": signature,
            "is_from_device": isFromDevice
        ]
        return client.request(AssistantRouter.registerDevice(params: params))
            .flatMap({ (data: RegisterResponseModel) -> Single<AppToken> in
                NetworkAdapter.shared.appToken = data.response.appToken
                return .just(data.response.appToken)
            })
    }
    
    public static func pushMessage(message: String, vaAgenId: String, nlpFeature: [String]) -> Single<String> {
        let params: [String: Any] = [
            "message": message,
            "va_agent_id": vaAgenId,
            "session_id": NetworkAdapter.shared.session_id ?? "",
            "nlp_features": nlpFeature
        ]
        
        return client.request(AssistantRouter.pushMessage(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "",
                                                          params: params))
            .flatMap({ (response: PushMessageResponse) -> Single<String> in
                return .just(response.messageId ?? "")
            })
    }
    
    public static func getVAResponse(by messageId: String) -> Single<VAResponse> {
        return client.request(AssistantRouter.getVAResponse(messageId: messageId,
                                                            deviceId: NetworkAdapter.shared.appToken?.deviceID ?? ""))
    }
}
