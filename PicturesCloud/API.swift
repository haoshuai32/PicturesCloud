//
//  API.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/1.
//

import Foundation
import Moya
import Photos

class API {
    static let shared = API()
    
    init() {}
    
    func login(username: String, password: String) {
        
    }
    
    func getPhotoList(type: Int) {
        
    }
    
    func uploadPhoto() {
        
    }
    
    func downloadPhoto() {
        
    }
}

// TODO: 登录

// TODO: 获取相册

// TODO: 上传照片

// TODO: 下载照片


// 数据管理协议

protocol PhotoAsset {
    var identifier: String {get}
    var mediaType: PHAssetMediaType {get}
    var mediaSubtypes: PHAssetMediaSubtype {get}
    var pixelWidth: Int {get}
    var pixelHeight: Int {get}
    var creationDate: Date? {get}
    var location: CLLocation?{get}
    var duration: Double {get}
}

//class CPhotoAsset:PhotoAsset {
//    // 传入json 对象进行数据解析
//}

class LPhotoAsset:PhotoAsset {
    
    let asset: PHAsset
  
    var identifier: String {
        return asset.localIdentifier
    }

    var mediaType: PHAssetMediaType {
        return asset.mediaType
    }
    
    var mediaSubtypes: PHAssetMediaSubtype {
        return asset.mediaSubtypes
    }

    var pixelWidth: Int {
        return asset.pixelWidth
    }

    var pixelHeight: Int {
        return asset.pixelHeight
    }

    var creationDate: Date? {
        return asset.creationDate
    }

    var location: CLLocation? {
        return asset.location
    }

    var duration: Double {
        return asset.duration
    }
    
    // Resource
    var assetResource:[PHAssetResource] = []
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    // 读取本地封面
    
    // 读取所有的资源数据
    
    // 上传数据
    
}
