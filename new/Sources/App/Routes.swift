import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    
    
    
    app.post("short") { req async throws -> ShortURLResponse in
        let urls = try req.content.decode(createURL.self)
        let original_url = urls.original_url
        let available_till = urls.available_till

        var shUrl = randomString(from: collectionOfChars, length: 6)
        while true {
            let exists = try await URLModel.query(on: req.db)
                .filter(\.$short_url == shUrl)
                .first()
            
            if exists == nil {
                break
            }
            
            shUrl = randomString(from: collectionOfChars, length: 6)
        }
        
        if let custom_url = urls.custom_url {
            let someUrl = URLModel(original_url: original_url, short_url: custom_url)
            if available_till != nil {
                someUrl.available_till = available_till
                try await someUrl.save(on: req.db)
                return .init(url: custom_url, available_till: someUrl.available_till!)
            }
            try await someUrl.save(on: req.db)
            return .init(url: shUrl, available_till: nil)
            
        } else {
            let someUrl = URLModel(original_url: original_url, short_url: shUrl)
            if available_till != nil {
                someUrl.available_till = available_till
                try await someUrl.save(on: req.db)
                return .init(url: shUrl, available_till: someUrl.available_till!)
            }
            try await someUrl.save(on: req.db)
            return .init(url: shUrl, available_till: nil)
        }
    }
    
    app.get("short", ":short_url") { req async throws -> urlResponse in
        let usersUrl = req.parameters.get("short_url")!
        let url = try await URLModel.query(on: req.db)
            .filter(\.$short_url == usersUrl)
            .first()
        if url == nil {
            return .init(response: "No such short url")
        }
        
    
        if url!.available_till != nil {
            if url!.available_till! < Date().timeIntervalSince1970 {
                try await url!.delete(on: req.db)
                return .init(response: "Short URL is not available")
            }
        }
        
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
        
        
        let analytics = AnalyticsModel(short_url: url!.short_url, url_id: url!.id!, user_ip: user_ip, user_agent: user_agent, app_lang: app_lang, device_name: device_name, platform: os, app_version: app_version, device_id: nil)
        
        try await analytics.save(on: req.db)
        
        return .init(response: url!.original_url)
        
    }
    
    app.put("short", ":short_url") { req async throws -> urlResponse in
        let oldUrl = req.parameters.get("short_url")!
        let url = try await URLModel.query(on: req.db)
            .filter(\.$short_url == oldUrl)
            .first()
        
        if url == nil {
            return .init(response: "No such short url")
        }
        
        let newUrl = try req.content.decode(updateURL.self)
        
        url!.short_url = newUrl.new_url
        url!.updated_at = Date().timeIntervalSince1970
        try await url!.save(on: req.db)
        return .init(response: url!.short_url)
    }
    ///
    
    app.delete("short", ":short_url") { req async throws -> urlResponse in
        let usersUrl = req.parameters.get("short_url")!
        let url = try await URLModel.query(on: req.db)
            .filter(\.$short_url == usersUrl)
            .first()
        
        if url == nil {
            return .init(response: "No such short url")
        }
        
        try await url!.delete(on: req.db)
        return .init(response: "Short URL was deleted")
        
    }
}


struct createURL: Content {
    var original_url: String
    var custom_url: String?
    var available_till: Double?
}
    
struct updateURL: Content {
    var new_url: String
    
}

struct ShortURLResponse: Content {
    let url: String
    let available_till: Double?
    
}

struct urlResponse: Content {
    let response: String
}
