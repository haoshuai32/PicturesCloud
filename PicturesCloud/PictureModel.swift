//
//  PictureModel.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos

enum Status: Int {
    case whole
    case local
    case downloading
    case cloud
    case uploading
}

struct PictureModel {
    
//    var cloudIdentifier: String?
    
    var cloudImageURL: URL?
    
    var cloudURL: URL?

    // 可以查询本地数据 可以查询云端数据
    var identifier: String = ""
    
    var mediaType: PHAssetMediaType = .unknown

    var mediaSubtypes: PHAssetMediaSubtype = .photoHDR

    var pixelWidth: Int = 0

    var pixelHeight: Int = 0

    var creationDate: Date?

    var modificationDate: Date?

    var location: CLLocation?
    
    var duration: Double = 0
    
    var uti: String = ""
    
    var fileName: String = ""
    
    var fileURL: String = ""
    
    var fileSize: Int = 0
}
