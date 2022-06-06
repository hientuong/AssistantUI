//
//  RegistrationDataModel.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 01/06/2022.
//

import Foundation

// MARK: - RegistrationData
public struct RegistrationData: Codable {
    public var deviceCode: String?
    public var vaReleaseVersionID: String?
    public var asrReleaseVersionID: String?
    public var ttsReleaseVersionID: String?
    public var vaAgentID: String?
    public var deviceModel: String?
    public var deviceInfo: DeviceInfo?
    public var deviceType: String?
    public var devicePublicKey: String?

    enum CodingKeys: String, CodingKey {
        case deviceCode = "device_code"
        case vaReleaseVersionID = "va_release_version_id"
        case asrReleaseVersionID = "asr_release_version_id"
        case ttsReleaseVersionID = "tts_release_version_id"
        case vaAgentID = "va_agent_id"
        case deviceModel = "device_model"
        case deviceInfo = "device_info"
        case deviceType = "device_type"
        case devicePublicKey = "device_public_key"
    }

    public init(deviceCode: String?, vaReleaseVersionID: String?, asrReleaseVersionID: String?, ttsReleaseVersionID: String?, vaAgentID: String?, deviceModel: String?, deviceInfo: DeviceInfo?, deviceType: String?, devicePublicKey: String?) {
        self.deviceCode = deviceCode
        self.vaReleaseVersionID = vaReleaseVersionID
        self.asrReleaseVersionID = asrReleaseVersionID
        self.ttsReleaseVersionID = ttsReleaseVersionID
        self.vaAgentID = vaAgentID
        self.deviceModel = deviceModel
        self.deviceInfo = deviceInfo
        self.deviceType = deviceType
        self.devicePublicKey = devicePublicKey
        
    }
}

// MARK: - DeviceInfo
public struct DeviceInfo: Codable {
    public var model: String?
    public var manufacture: String?
    public var vin: String?
    public var modelYear: Int?
    public var fuelCapacity: Int?
    public var variant: String?
    public var market: String?
    public var carType: String?
    public var swVersion: String?
    public var hwVersion: String?

    enum CodingKeys: String, CodingKey {
        case model = "model"
        case manufacture = "manufacture"
        case vin = "vin"
        case modelYear = "model_year"
        case fuelCapacity = "fuel_capacity"
        case variant = "variant"
        case market = "market"
        case carType = "car_type"
        case swVersion = "sw_version"
        case hwVersion = "hw_version"
    }

    public init(model: String?, manufacture: String?, vin: String?, modelYear: Int?, fuelCapacity: Int?, variant: String?, market: String?, carType: String?, swVersion: String?, hwVersion: String?) {
        self.model = model
        self.manufacture = manufacture
        self.vin = vin
        self.modelYear = modelYear
        self.fuelCapacity = fuelCapacity
        self.variant = variant
        self.market = market
        self.carType = carType
        self.swVersion = swVersion
        self.hwVersion = hwVersion
    }
}
