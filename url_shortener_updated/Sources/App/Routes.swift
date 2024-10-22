import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.post("short") { req async throws -> ShortURLResponse in
        let url = try req.content.decode(createURL.self)
        let long_url = url.long_url
        let context = url.context.data(using: .utf8)!
        
        
        let url_to_save = URLModel(long_url: long_url, context: context)
        try await url_to_save.save(on: req.db)
        
        let shUrl = toBase62(number: try url_to_save.requireID())
        return .init(short_url: shUrl)
    }
    
    
    app.get("short", ":short_url") { req async throws -> urlResponse in
        let short_url = req.parameters.get("short_url")!
        let short_url_id = fromBase62(base_62_string: short_url)
        //
        let url = try await URLModel.query(on: req.db)
            .filter(\.$id == short_url_id)
            .first()
        if url == nil {
            return .init(response: "No such short url")}
        //
        //
        let app_lang = req.headers["Accept-Language"].first!
        let user_ip = req.peerAddress!.ipAddress!
        let parts = req.headers["User-Agent"].first!.components(separatedBy: " ")
        let user_agent = req.headers["User-Agent"].first!
        let device_name = req.headers.first(name: .userAgent) ?? "Unknown"
        let app_version = String(req.headers["User-Agent"].first!.split(separator: "/").last!)
        
        var os = ""
        for part in parts {
            if part.contains("Windows") {
                os = "Windows"
            } else if part.contains("Android") {
                os = "Android"
            } else if part.contains("iOS") {
                os = "iOS"
            } else if part.contains("Macintosh") {
                os = "Macintosh"
            }
        }
        
        
        let analytics = AnalyticsModel(long_url: url!.long_url, user_ip: user_ip, user_agent: user_agent, app_lang: app_lang, device_name: device_name, platform: os, app_version: app_version, device_id: nil)
        
        try await analytics.save(on: req.db)
        ////
        return .init(response: url!.long_url)
        
    }
    
    
    app.put("short", ":short_url") { req async throws -> urlResponse in
        let short_url = req.parameters.get("short_url")!
        let short_url_id = fromBase62(base_62_string: short_url)
        let context = try req.content.decode(updateContext.self).new_context
        
        let url = try await URLModel.query(on: req.db)
            .filter(\.$id == short_url_id)
            .first()
        
        url!.context = context.data(using: .utf8)!
        try await url?.update(on: req.db)
        
        return .init(response: context)
        
    }
}


struct createURL: Content {
    var long_url: String
    var context: String
}
    
struct updateContext: Content {
    var new_context: String

}

struct ShortURLResponse: Content {
    let short_url: String
}

struct urlResponse: Content {
    let response: String
}
