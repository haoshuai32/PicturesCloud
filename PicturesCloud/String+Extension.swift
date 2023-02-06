//
//  String+Extension.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/6.
//

import Foundation
private let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789".map{$0}
extension String {
    static func randomString(length:Int) -> String {
        var result = ""
        for _ in 0..<length {
            
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            result.append(characters[index])
        }
        return result
    }
}
