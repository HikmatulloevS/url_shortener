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
            .id()
            .field(.original_url, .string)
            .field(.short_url, .string)
            .field(.available_till, .double)
            .field(.created_at, .double)
            .field(.updated_at, .double)
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
            .field(.url, .string)
            .field(.url_id, .uuid)
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
