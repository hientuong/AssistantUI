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
        let sessionId = NetworkAdapter.shared.session_id ?? ""
        let params: [String: Any] = [
            "message": message,
            "va_agent_id": vaAgenId,
            "session_id": sessionId,
            "nlp_features": nlpFeature
        ]
        
        return client.request(AssistantRouter.pushMessage(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "",
                                                          params: params))
            .flatMap({ (response: PushMessageResponse) -> Single<String> in
                NetworkAdapter.shared.currentSessionId = sessionId
                return .just(response.messageId ?? "")
            })
    }
    
    public static func getVAResponse(by messageId: String) -> Single<VAResponse> {
        return client.request(AssistantRouter.getVAResponse(messageId: messageId,
                                                            deviceId: NetworkAdapter.shared.appToken?.deviceID ?? ""))
    }

    public static func getVAResponse() -> Single<VAResponse> {
        return client.request(AssistantRouter.getVaResponseBySession(deviceId: NetworkAdapter.shared.appToken?.deviceID ?? "",
                                                                     sessionId: NetworkAdapter.shared.currentSessionId ?? ""))
    }
    
    public static func generateAudio(text: String,
                                     languageCode: String,
                                     voiceName: String,
                                     generator: String,
                                     acousticModel: String,
                                     style: String,
                                     ouputFormat: String) -> Single<AudioResponse> {
        let params: [String: Any] = [
            "text": text,
            "language_code": languageCode,
            "voice_name": voiceName,
            "generator": generator,
            "acoustic_model": acousticModel,
            "style": style,
            "output_format": ouputFormat
        ]
        return client.request(AssistantRouter.generateAudio(params: params))
    }
}
