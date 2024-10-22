//
//  File.swift
//  
//
//  Created by Nexus 1 on 9/25/24.
//

import Foundation
import Fluent
import Vapor


final class URLModel: Model {
    static let schema = "main"
    
    @ID(custom: .id)
    var id: Int?
    
    @Field(key: .long_url) var long_url: String
    
    @Field(key: .context) var context: Data
    
    @Field(key: .version) var version: Int
    
    init() {}
    
    init(long_url: String, context: Data) {
        self.long_url = long_url
        self.context = context
        self.version = 1
    }
    
}

extension FieldKey {
    static var long_url: Self {"long_url"}
    static var context: Self {"context"}
    static var version: Self {"version"}
}



final class AnalyticsModel: Model {
    static let schema = "analytics"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: .long_url) var long_url: String
    
    @Field(key: .user_ip) var user_ip: String
    
    @Field(key: .user_agent) var user_agent: String
    
    @Field(key: .app_language) var app_language: String
    
    @OptionalField(key: .device_name) var device_name: String?
    
    @Field(key: .platform) var platform: String
    
    @Field(key: .app_version) var app_version: String

    init() {}
    
    init(long_url: String, user_ip: String, user_agent: String, app_lang: String, device_name: String? = nil, platform: String, app_version: String, device_id: String? = nil) {
        self.long_url = long_url
        self.user_ip = user_ip
        self.user_agent = user_agent
        self.app_language = app_lang
        self.device_name = device_name
        self.platform = platform
        self.app_version = app_version
    }
}
    
extension FieldKey {
//    static var
    static var user_ip: Self {"user_ip"}
    static var user_agent: Self {"user_agent"}
    static var app_language: Self {"app_language"}
    static var device_name: Self {"device_name"}
    static var api_key: Self {"api_key"}
    static var platform: Self {"platform"}
    static var app_version: Self {"app_version"}
}
