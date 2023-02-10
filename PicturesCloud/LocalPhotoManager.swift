//
//  LocalPhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/9.
//



// 原始数据


import Foundation
import CoreLocation

enum PhotoAssetType {
    
}

protocol PhotoAsset {
    var identifier: String {set get}
    var photoType: PhotoAssetType  {set get}
    var pixelWidth: Int {set get}
    var pixelHeight: Int {set get}
    var creationDate: Date? {set get}
    var location: CLLocation?{set get}
    var duration: Double {set get}
}

//class LocalPhotoAsset: PhotoAsset {
//
//}

protocol PhotoManager {
    
    // dataSource
    
    // selectDataSource
    
    // reload()
    
    // loadmore()
    
    
    
    // 选择的数据
    
    // 获取照片
    
    // 缓存照片
    
    // 显示大照片
    
}



