//
////  File.swift
////  
////
////  Created by Nexus 1 on 7/31/24.
////
//
import Foundation
import Vapor
import Fluent

func toBase62(number: Int) -> String {
    let base_62_characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    var result = ""
    var num = number

    if num == 0 {
        return "0"
    }

    while num > 0 {
        let remainder = num % 62
        let index = base_62_characters.index(base_62_characters.startIndex, offsetBy: remainder)
        result = String(base_62_characters[index]) + result
        num /= 62
    }

    return result
}



func fromBase62(base_62_string: String) -> Int {
    let base_62_characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    var decimal_number = 0
    var power = 0

    for character in base_62_string.reversed() {
        if let index = base_62_characters.firstIndex(of: character) {
            let base_62_value = base_62_characters.distance(from: base_62_characters.startIndex, to: index)
            decimal_number += base_62_value * (1 << (power * 6))
            power += 1
        } else {
            print("Invalid character: \(character)")
            return 0
        }
    }

    return decimal_number
}
