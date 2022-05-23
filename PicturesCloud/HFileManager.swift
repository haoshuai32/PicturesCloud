//
//  HFileManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation

struct HFileManager {
    
    static let shared = HFileManager()
    
    let fileManager: FileManager
    
    
    
    lazy var sqlite: String = {
        return ""
    }()
    
    init() {
        fileManager = FileManager.default
    }
    
    
    
    
    
}
