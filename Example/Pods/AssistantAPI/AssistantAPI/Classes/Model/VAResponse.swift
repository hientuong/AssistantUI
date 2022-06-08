//
//  VAResponse.swift
//  AssistantAPI
//
//  Created by Cong Nguyen on 03/06/2022.
//

import Foundation
import ObjectMapper

// MARK: - VAResponse
public struct VAResponse: Codable {
    public var message: String?
    public var errorCode: Int?
    public var vaData: VAData?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case errorCode = "error_code"
        case vaData = "data"
    }

    public init(message: String?, errorCode: Int?, data: VAData?) {
        self.message = message
        self.errorCode = errorCode
        self.vaData = data
    }
}

// MARK: - DataClass
public struct VAData: Codable {
    public var kbAnswer: String?
    public var nerResponse: [AnyCodable]?
    public var inferStatus: InferStatus?
    public var dmResponse: DmResponse?
    public var isAllDone: Bool?

    enum CodingKeys: String, CodingKey {
        case kbAnswer = "kb_answer"
        case nerResponse = "ner_response"
        case inferStatus = "infer_status"
        case dmResponse = "dm_response"
        case isAllDone = "is_all_done"
    }

    public init(kbAnswer: String?, nerResponse: [AnyCodable]?, inferStatus: InferStatus?, dmResponse: DmResponse?, isAllDone: Bool?) {
        self.kbAnswer = kbAnswer
        self.nerResponse = nerResponse
        self.inferStatus = inferStatus
        self.dmResponse = dmResponse
        self.isAllDone = isAllDone
    }
}

// MARK: - DmResponse
public struct DmResponse: Codable {
    public var botMessage: [BotMessage]?
    public var dialogResponse: DialogResponse?
    public var vaAgentInfo: VaAgentInfo?
    public var messageObject: MessageObject?
    public var sessionId: String?

    enum CodingKeys: String, CodingKey {
        case botMessage = "bot_message"
        case dialogResponse = "dialog_response"
        case vaAgentInfo = "va_agent_info"
        case messageObject = "message_object"
        case sessionId = "session_id"
    }

    public init(botMessage: [BotMessage]?, dialogResponse: DialogResponse?, vaAgentInfo: VaAgentInfo?, messageObject: MessageObject?, sessionId: String?) {
        self.botMessage = botMessage
        self.dialogResponse = dialogResponse
        self.vaAgentInfo = vaAgentInfo
        self.messageObject = messageObject
        self.sessionId = sessionId
    }
}

// MARK: - BotMessage
public struct BotMessage: Codable {
    public var type: BotMessageType?
    public var value: String?
    public var modelName: String?
    public var pitch: Int?
    public var speed: Int?

    public func getBotMessageValueObject() -> Any? {
        if self.type == .list {
            if let jsonData = value?.toJSON() as? [String: Any] {
                let botMediaList = BotMessageList(JSON: jsonData, context: nil)
                return botMediaList
            }
        } else if self.type == .media {
            if let jsonData = value?.toJSON() as? [String: Any] {
                let botMedia = BotMessageMedia(JSON: jsonData, context: nil)
                return botMedia
            }
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case value = "value"
        case modelName = "model_name"
        case pitch = "pitch"
        case speed = "speed"
    }

    public init(type: BotMessageType?, value: String?, modelName: String?, pitch: Int?, speed: Int?) {
        self.type = type
        self.value = value
        self.modelName = modelName
        self.pitch = pitch
        self.speed = speed
    }
}

public enum BotMessageType: String, Codable {
    case list = "list"
    case text = "text"
    case voice = "voice"
    case media = "media"
    case button = "button"
    case carousel = "carousel"
    case quick_reply = "quick_reply"
}

// MARK: - BotMessageMedia
public struct BotMessageMedia: Codable, Mappable {
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        imgUrl <- map[CodingKeys.imgUrl.rawValue]
        mediaType <- map[CodingKeys.mediaType.rawValue]
        title <- map[CodingKeys.title.rawValue]
        subtitle <- map[CodingKeys.subtitle.rawValue]
        defaultAction <- map[CodingKeys.defaultAction.rawValue]
        buttons <- map[CodingKeys.buttons.rawValue]
    }
    
    public var imgUrl: String?
    public var mediaType: String?
    public var title: String?
    public var subtitle: String?
    public var defaultAction: AnyCodable?
    public var buttons: [AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case imgUrl = "img_url"
        case mediaType = "media_type"
        case title = "title"
        case subtitle = "subtitle"
        case defaultAction = "default_action"
        case buttons = "buttons"
    }

    public init(imgUrl: String?,
                mediaType: String?,
                title: String?,
                subtitle: String?,
                defaultAction: AnyCodable?,
                buttons: [AnyCodable]?) {
        self.imgUrl = imgUrl
        self.mediaType = mediaType
        self.title = title
        self.subtitle = subtitle
        self.defaultAction = defaultAction
        self.buttons = buttons
    }
}

// MARK: - BotMessageList
public struct BotMessageList: Codable, Mappable {
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        items <- map[CodingKeys.items.rawValue]
        buttons <- map[CodingKeys.buttons.rawValue]
    }
    
    
    public var items: [Item]?
    public var buttons: [AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case items = "items"
        case buttons = "buttons"
    }

    public init(items: [Item]?, buttons: [AnyCodable]?) {
        self.items = items
        self.buttons = buttons
    }
}

// MARK: - Item
public struct Item: Codable, Mappable {
    public var imgUrl: String?
    public var title: String?
    public var subtitle: String?
    public var buttons: [AnyCodable]?
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        imgUrl <- map[CodingKeys.imgUrl.rawValue]
        title <- map[CodingKeys.title.rawValue]
        subtitle <- map[CodingKeys.subtitle.rawValue]
        buttons <- map[CodingKeys.buttons.rawValue]
    }

    enum CodingKeys: String, CodingKey {
        case imgUrl = "img_url"
        case title = "title"
        case subtitle = "subtitle"
        case buttons = "buttons"
    }

    public init(imgUrl: String?, title: String?, subtitle: String?, buttons: [AnyCodable]?) {
        self.imgUrl = imgUrl
        self.title = title
        self.subtitle = subtitle
        self.buttons = buttons
    }
}


// MARK: - DialogResponse
public struct DialogResponse: Codable {
    public var data: [BotMessage]?
    public var debugData: DebugData?
    public var errorCode: Int?
    public var isQna: Bool?
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case data = "data"
        case debugData = "debug_data"
        case errorCode = "error_code"
        case isQna = "is_qna"
        case message = "message"
    }

    public init(data: [BotMessage]?, debugData: DebugData?, errorCode: Int?, isQna: Bool?, message: String?) {
        self.data = data
        self.debugData = debugData
        self.errorCode = errorCode
        self.isQna = isQna
        self.message = message
    }
}

// MARK: - DebugData
public struct DebugData: Codable {
    public var conversation: Conversation?
    public var hasDelay: Bool?
    public var hasMissing: Bool?
    public var keepQnaAnswer: Bool?
    public var lastMissing: Bool?
    public var logs: Logs?
    public var message: [BotMessage]?
    public var nlp: NLP?
    public var popupForm: AnyCodable?
    public var statusSkill: StatusSkill?

    enum CodingKeys: String, CodingKey {
        case conversation = "conversation"
        case hasDelay = "hasDelay"
        case hasMissing = "hasMissing"
        case keepQnaAnswer = "keepQnaAnswer"
        case lastMissing = "lastMissing"
        case logs = "logs"
        case message = "message"
        case nlp = "nlp"
        case popupForm = "popup_form"
        case statusSkill = "statusSkill"
    }

    public init(conversation: Conversation?, hasDelay: Bool?, hasMissing: Bool?, keepQnaAnswer: Bool?, lastMissing: Bool?, logs: Logs?, message: [BotMessage]?, nlp: NLP?, popupForm: AnyCodable?, statusSkill: StatusSkill?) {
        self.conversation = conversation
        self.hasDelay = hasDelay
        self.hasMissing = hasMissing
        self.keepQnaAnswer = keepQnaAnswer
        self.lastMissing = lastMissing
        self.logs = logs
        self.message = message
        self.nlp = nlp
        self.popupForm = popupForm
        self.statusSkill = statusSkill
    }
}

// MARK: - Conversation
public struct Conversation: Codable {
    public var countConfuse: Int?
    public var delayAction: Bool?
    public var domain: String?
    public var flowNext: [AnyCodable]?
    public var followUp: Bool?
    public var hateSpeech: HateSpeech?
    public var id: String?
    public var mapDelay: MapDelay?
    public var mapIndex: MapDelay?
    public var mapMissing: MapDelay?
    public var memory: Memory?
    public var preQna: Int?
    public var preSkill: [String]?
    public var skill: String?
    public var skillOccurences: Int?
    public var source: String?
    public var spokenText: String?
    public var timeEpoch: Int?
    public var variables: Variables?
    public var waitForInput: Bool?

    enum CodingKeys: String, CodingKey {
        case countConfuse = "count_confuse"
        case delayAction = "delay_action"
        case domain = "domain"
        case flowNext = "flow_next"
        case followUp = "follow_up"
        case hateSpeech = "hate_speech"
        case id = "id"
        case mapDelay = "map_delay"
        case mapIndex = "map_index"
        case mapMissing = "map_missing"
        case memory = "memory"
        case preQna = "pre_qna"
        case preSkill = "pre_skill"
        case skill = "skill"
        case skillOccurences = "skill_occurences"
        case source = "source"
        case spokenText = "spoken_text"
        case timeEpoch = "time_epoch"
        case variables = "variables"
        case waitForInput = "wait_for_input"
    }

    public init(countConfuse: Int?, delayAction: Bool?, domain: String?, flowNext: [AnyCodable]?, followUp: Bool?, hateSpeech: HateSpeech?, id: String?, mapDelay: MapDelay?, mapIndex: MapDelay?, mapMissing: MapDelay?, memory: Memory?, preQna: Int?, preSkill: [String]?, skill: String?, skillOccurences: Int?, source: String?, spokenText: String?, timeEpoch: Int?, variables: Variables?, waitForInput: Bool?) {
        self.countConfuse = countConfuse
        self.delayAction = delayAction
        self.domain = domain
        self.flowNext = flowNext
        self.followUp = followUp
        self.hateSpeech = hateSpeech
        self.id = id
        self.mapDelay = mapDelay
        self.mapIndex = mapIndex
        self.mapMissing = mapMissing
        self.memory = memory
        self.preQna = preQna
        self.preSkill = preSkill
        self.skill = skill
        self.skillOccurences = skillOccurences
        self.source = source
        self.spokenText = spokenText
        self.timeEpoch = timeEpoch
        self.variables = variables
        self.waitForInput = waitForInput
    }
}

// MARK: - HateSpeech
public struct HateSpeech: Codable {
    public var toxicity: Int?

    enum CodingKeys: String, CodingKey {
        case toxicity = "toxicity"
    }

    public init(toxicity: Int?) {
        self.toxicity = toxicity
    }
}

// MARK: - MapDelay
public struct MapDelay: Codable {

    public init() {
    }
}

// MARK: - Memory
public struct Memory: Codable {
    public var channelId: String?
    public var channelType: String?
    public var inputType: String?
    public var language: String?
    public var lastInfo: LastInfo?
    public var messageType: String?

    enum CodingKeys: String, CodingKey {
        case channelId = "_channel.id"
        case channelType = "_channel.type"
        case inputType = "_input.type"
        case language = "_language"
        case lastInfo = "_last_info"
        case messageType = "_message.type"
    }

    public init(channelId: String?, channelType: String?, inputType: String?, language: String?, lastInfo: LastInfo?, messageType: String?) {
        self.channelId = channelId
        self.channelType = channelType
        self.inputType = inputType
        self.language = language
        self.lastInfo = lastInfo
        self.messageType = messageType
    }
}

// MARK: - LastInfo
public struct LastInfo: Codable {
    public var channelId: String?
    public var channelType: String?
    public var language: String?
    public var entities: Entities?
    public var intents: Intents?
    public var message: [BotMessage]?
    public var source: String?

    enum CodingKeys: String, CodingKey {
        case channelId = "_channel.id"
        case channelType = "_channel.type"
        case language = "_language"
        case entities = "entities"
        case intents = "intents"
        case message = "message"
        case source = "source"
    }

    public init(channelId: String?, channelType: String?, language: String?, entities: Entities?, intents: Intents?, message: [BotMessage]?, source: String?) {
        self.channelId = channelId
        self.channelType = channelType
        self.language = language
        self.entities = entities
        self.intents = intents
        self.message = message
        self.source = source
    }
}

// MARK: - Entities
public struct Entities: Codable {
    public var address: [Address]?

    enum CodingKeys: String, CodingKey {
        case address = "ADDRESS"
    }

    public init(address: [Address]?) {
        self.address = address
    }
}

// MARK: - Address
public struct Address: Codable {
    public var addressClass: String?
    public var confidence: Double?
    public var endOffset: Int?
    public var entityClass: String?
    public var name: String?
    public var queryId: String?
    public var raw: String?
    public var startOffset: Int?
    public var type: String?
    public var value: String?

    enum CodingKeys: String, CodingKey {
        case addressClass = "class"
        case confidence = "confidence"
        case endOffset = "end_offset"
        case entityClass = "entity_class"
        case name = "name"
        case queryId = "query_id"
        case raw = "raw"
        case startOffset = "start_offset"
        case type = "type"
        case value = "value"
    }

    public init(addressClass: String?, confidence: Double?, endOffset: Int?, entityClass: String?, name: String?, queryId: String?, raw: String?, startOffset: Int?, type: String?, value: String?) {
        self.addressClass = addressClass
        self.confidence = confidence
        self.endOffset = endOffset
        self.entityClass = entityClass
        self.name = name
        self.queryId = queryId
        self.raw = raw
        self.startOffset = startOffset
        self.type = type
        self.value = value
    }
}

// MARK: - Intents
public struct Intents: Codable {
    public var confidence: Double?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case name = "name"
    }

    public init(confidence: Double?, name: String?) {
        self.confidence = confidence
        self.name = name
    }
}

// MARK: - Variables
public struct Variables: Codable {
    public var agentId: String?
    public var channelId: String?
    public var userId: Double?

    enum CodingKeys: String, CodingKey {
        case agentId = "agent_id"
        case channelId = "channel_id"
        case userId = "user_id"
    }

    public init(agentId: String?, channelId: String?, userId: Double?) {
        self.agentId = agentId
        self.channelId = channelId
        self.userId = userId
    }
}

// MARK: - Logs
public struct Logs: Codable {
    public var errorCode: Int?
    public var isQuestion: Bool?
    public var memoryTrace: MapDelay?
    public var message: String?
    public var textTrace: TextTrace?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case isQuestion = "is_question"
        case memoryTrace = "memory_trace"
        case message = "message"
        case textTrace = "text_trace"
    }

    public init(errorCode: Int?, isQuestion: Bool?, memoryTrace: MapDelay?, message: String?, textTrace: TextTrace?) {
        self.errorCode = errorCode
        self.isQuestion = isQuestion
        self.memoryTrace = memoryTrace
        self.message = message
        self.textTrace = textTrace
    }
}

// MARK: - TextTrace
public struct TextTrace: Codable {
    public var mktGreeting: [BotMessage]?

    enum CodingKeys: String, CodingKey {
        case mktGreeting = "MKT_GREETING"
    }

    public init(mktGreeting: [BotMessage]?) {
        self.mktGreeting = mktGreeting
    }
}

// MARK: - NLP
public struct NLP: Codable {
    public var act: String?
    public var domain: String?
    public var entities: Entities?
    public var intents: [Intent]?
    public var languageDefault: String?
    public var languageProcessing: String?
    public var sentiment: String?
    public var source: String?
    public var spokenText: String?
    public var status: Int?
    public var timestamp: String?
    public var titleAsk: String?
    public var type: BotMessageType?
    public var uuid: String?
    public var version: String?

    enum CodingKeys: String, CodingKey {
        case act = "act"
        case domain = "domain"
        case entities = "entities"
        case intents = "intents"
        case languageDefault = "language_default"
        case languageProcessing = "language_processing"
        case sentiment = "sentiment"
        case source = "source"
        case spokenText = "spoken_text"
        case status = "status"
        case timestamp = "timestamp"
        case titleAsk = "title_ask"
        case type = "type"
        case uuid = "uuid"
        case version = "version"
    }

    public init(act: String?, domain: String?, entities: Entities?, intents: [Intent]?, languageDefault: String?, languageProcessing: String?, sentiment: String?, source: String?, spokenText: String?, status: Int?, timestamp: String?, titleAsk: String?, type: BotMessageType?, uuid: String?, version: String?) {
        self.act = act
        self.domain = domain
        self.entities = entities
        self.intents = intents
        self.languageDefault = languageDefault
        self.languageProcessing = languageProcessing
        self.sentiment = sentiment
        self.source = source
        self.spokenText = spokenText
        self.status = status
        self.timestamp = timestamp
        self.titleAsk = titleAsk
        self.type = type
        self.uuid = uuid
        self.version = version
    }
}

// MARK: - Intent
public struct Intent: Codable {
    public var confidence: Double?
    public var name: String?
    public var slug: String?

    enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case name = "name"
        case slug = "slug"
    }

    public init(confidence: Double?, name: String?, slug: String?) {
        self.confidence = confidence
        self.name = name
        self.slug = slug
    }
}

// MARK: - StatusSkill
public struct StatusSkill: Codable {
    public var statusSkillBreak: [AnyCodable]?
    public var end: [String]?
    public var start: [String]?

    enum CodingKeys: String, CodingKey {
        case statusSkillBreak = "break"
        case end = "end"
        case start = "start"
    }

    public init(statusSkillBreak: [AnyCodable]?, end: [String]?, start: [String]?) {
        self.statusSkillBreak = statusSkillBreak
        self.end = end
        self.start = start
    }
}

// MARK: - MessageObject
public struct MessageObject: Codable {
    public var created: String?
    public var deviceId: String?
    public var vaAgentId: String?
    public var profileId: String?
    public var sessionId: String?
    public var messageCreatedAt: Double?
    public var status: String?
    public var messageText: String?
    public var nlpResults: [AnyCodable]?
    public var adapterType: AnyCodable?
    public var nlpFeatures: [String]?
    public var voice: AnyCodable?
    public var id: String?

    enum CodingKeys: String, CodingKey {
        case created = "created"
        case deviceId = "device_id"
        case vaAgentId = "va_agent_id"
        case profileId = "profile_id"
        case sessionId = "session_id"
        case messageCreatedAt = "message_created_at"
        case status = "status"
        case messageText = "message_text"
        case nlpResults = "nlp_results"
        case adapterType = "adapter_type"
        case nlpFeatures = "nlp_features"
        case voice = "voice"
        case id = "id"
    }

    public init(created: String?, deviceId: String?, vaAgentId: String?, profileId: String?, sessionId: String?, messageCreatedAt: Double?, status: String?, messageText: String?, nlpResults: [AnyCodable]?, adapterType: AnyCodable?, nlpFeatures: [String]?, voice: AnyCodable?, id: String?) {
        self.created = created
        self.deviceId = deviceId
        self.vaAgentId = vaAgentId
        self.profileId = profileId
        self.sessionId = sessionId
        self.messageCreatedAt = messageCreatedAt
        self.status = status
        self.messageText = messageText
        self.nlpResults = nlpResults
        self.adapterType = adapterType
        self.nlpFeatures = nlpFeatures
        self.voice = voice
        self.id = id
    }
}

// MARK: - VaAgentInfo
public struct VaAgentInfo: Codable {
    public var id: String?
    public var created: Int?
    public var vaAgentName: String?
    public var chatbotAgentId: String?
    public var ownerId: String?
    public var chatbotChannelId: String?
    public var accessToken: String?
    public var mappingResponseFilePath: String?
    public var ttsProjectId: AnyCodable?
    public var asrProjectId: AnyCodable?
    public var deviceModels: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created = "created"
        case vaAgentName = "va_agent_name"
        case chatbotAgentId = "chatbot_agent_id"
        case ownerId = "owner_id"
        case chatbotChannelId = "chatbot_channel_id"
        case accessToken = "access_token"
        case mappingResponseFilePath = "mapping_response_file_path"
        case ttsProjectId = "tts_project_id"
        case asrProjectId = "asr_project_id"
        case deviceModels = "device_models"
    }

    public init(id: String?, created: Int?, vaAgentName: String?, chatbotAgentId: String?, ownerId: String?, chatbotChannelId: String?, accessToken: String?, mappingResponseFilePath: String?, ttsProjectId: AnyCodable?, asrProjectId: AnyCodable?, deviceModels: [String]?) {
        self.id = id
        self.created = created
        self.vaAgentName = vaAgentName
        self.chatbotAgentId = chatbotAgentId
        self.ownerId = ownerId
        self.chatbotChannelId = chatbotChannelId
        self.accessToken = accessToken
        self.mappingResponseFilePath = mappingResponseFilePath
        self.ttsProjectId = ttsProjectId
        self.asrProjectId = asrProjectId
        self.deviceModels = deviceModels
    }
}

// MARK: - InferStatus
public struct InferStatus: Codable {
    public var kb: String?
    public var nerWeather: String?
    public var nerSms: String?
    public var nerAudioBook: String?
    public var nerStock: String?
    public var nerMovie: String?
    public var nerGeneral: String?
    public var dm: String?

    enum CodingKeys: String, CodingKey {
        case kb = "kb"
        case nerWeather = "ner_weather"
        case nerSms = "ner_sms"
        case nerAudioBook = "ner_audio_book"
        case nerStock = "ner_stock"
        case nerMovie = "ner_movie"
        case nerGeneral = "ner_general"
        case dm = "dm"
    }

    public init(kb: String?, nerWeather: String?, nerSms: String?, nerAudioBook: String?, nerStock: String?, nerMovie: String?, nerGeneral: String?, dm: String?) {
        self.kb = kb
        self.nerWeather = nerWeather
        self.nerSms = nerSms
        self.nerAudioBook = nerAudioBook
        self.nerStock = nerStock
        self.nerMovie = nerMovie
        self.nerGeneral = nerGeneral
        self.dm = dm
    }
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
