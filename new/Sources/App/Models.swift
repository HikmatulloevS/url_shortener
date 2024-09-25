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
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: .original_url) var original_url: String
    
    @Field(key: .short_url) var short_url: String
    
    @Field(key: .available_till) var available_till: Double?

    @Field(key: .created_at) var created_at: Double
    
    @OptionalField(key: .updated_at) var updated_at: Double?

    init() {}
    
    init(original_url: String, short_url: String, available_till: Double? = nil) {
        self .original_url = original_url
        self .short_url = short_url
        self .created_at = Date().timeIntervalSince1970
        self .available_till = available_till
    }
    
}

extension FieldKey {
    static var original_url: Self {"original_url"}
    static var short_url : Self {"short_url"}
    static var created_at: Self {"created_at"}
    static var updated_at: Self {"updated_at"}
    static var available_till: Self {"available_till"}
    
}



final class AnalyticsModel: Model {
    static let schema = "analytics"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: .url) var short_url: String
    
    @Field(key: .url_id) var url_id: UUID
    
    @Field(key: .user_ip) var user_ip: String
    
    @Field(key: .user_agent) var user_agent: String
    
    @Field(key: .app_language) var app_language: String
    
    @OptionalField(key: .device_name) var device_name: String?
    
    @Field(key: .platform) var platform: String
    
    @Field(key: .app_version) var app_version: String

    init() {}
    
    init(short_url: String, url_id: UUID, user_ip: String, user_agent: String, app_lang: String, device_name: String? = nil, platform: String, app_version: String, device_id: String? = nil) {
        self.short_url = short_url
        self.url_id = url_id
        self.user_ip = user_ip
        self.user_agent = user_agent
        self.app_language = app_lang
        self.device_name = device_name
        self.platform = platform
        self.app_version = app_version
    }
}
    
    
extension FieldKey {
    static var url: Self {"url"}
    static var url_id: Self {"url_id"}
    static var user_ip: Self {"user_ip"}
    static var user_agent: Self {"user_agent"}
    static var app_language: Self {"app_language"}
    static var device_name: Self {"device_name"}
    static var api_key: Self {"api_key"}
    static var platform: Self {"platform"}
    static var app_version: Self {"app_version"}
}
