//
//  HFileManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation

struct HFileManager {
    
    
    
    static var shared = HFileManager()
    
    let fileManager: FileManager
    

    lazy var downloadDirectory: URL = {
        let directoryURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return directoryURLs.first!
    }()
    
    lazy var tempFile: URL = {

        let url = downloadDirectory.appendingPathComponent("temp.file")
        
//        if (fileManager.fileExists(atPath: url.path)) {
//            try! fileManager.removeItem(at: url)
//        }

        return url
    }()
    
    lazy var tempImg: URL = {
        
        let url = downloadDirectory.appendingPathComponent("temp.jpg")
        
//        if (fileManager.fileExists(atPath: url.path)) {
//            try! fileManager.removeItem(at: url)
//        }

        
        
        return url
    }()
    
    lazy var tempMov: URL = {
      
        let url = downloadDirectory.appendingPathComponent("temp.mov")
        
//        if (fileManager.fileExists(atPath: url.path)) {
//            try! fileManager.removeItem(at: url)
//        }

        return url
    }()
    
    lazy var sqlite: String = {
        return ""
    }()
    
    init() {
        fileManager = FileManager.default
    }
    
    
    
    
    
}
