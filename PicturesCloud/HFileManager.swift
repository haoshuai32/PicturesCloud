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
    
    lazy var downloadTemp: URL = {
        let temp = NSTemporaryDirectory()
        var url = URL(fileURLWithPath: temp)
        url.appendPathComponent("download.temp")
//        debugPrint("upload temp", url)
        return url
    }()
    
    lazy var uploadTemp: URL = {
        let temp = NSTemporaryDirectory()
        var url = URL(fileURLWithPath: temp)
        url.appendPathComponent("upload.temp")
//        debugPrint("upload temp", url)
        return url
    }()
    
    lazy var sqlite: String = {
        return ""
    }()
    
    init() {
        fileManager = FileManager.default
    }
    
    
    
    
    
}
