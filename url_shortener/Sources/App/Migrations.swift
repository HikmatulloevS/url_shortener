//
//  File.swift
//  
//
//  Created by Nexus 1 on 9/25/24.
//

import Foundation
import Vapor
import Fluent


struct URLMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("main")
            .field("id", .int, .identifier(auto: true))
            .field(.long_url, .string)
            .field(.context, .json)
            .field(.version, .int)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("main").delete()
    }
}



struct Analyticsigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("analytics")
            .id()
            .field(.long_url, .string)
            .field(.user_ip, .string)
            .field(.user_agent, .string)
            .field(.app_language, .string)
            .field(.device_name, .string)
            .field(.platform, .string)
            .field(.app_version, .string)
            .field(.api_key, .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("analytics").delete()
    }
}
