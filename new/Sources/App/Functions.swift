//
//  File.swift
//  
//
//  Created by Nexus 1 on 7/31/24.
//

import Foundation
import Vapor
import Fluent

let collectionOfChars = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func randomString(from characters: String, length: Int) -> String {
    var randomString = ""
    let charactersArray = Array(characters)

    for _ in 0..<length {
        let randomIndex = Int.random(in: 0..<charactersArray.count)
        randomString += String(charactersArray[randomIndex])
    }

    return randomString
}

