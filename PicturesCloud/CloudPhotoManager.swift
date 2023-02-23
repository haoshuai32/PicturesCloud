//
//  CloudPhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/9.
//

import Foundation
import Photos
import UIKit

class CloudAssetManager: AssetManager {
    
    typealias T = Photo
    
    var dataSource: [PhotoAsset] = []
    
    var selectDataSource: Set<PhotoAsset> = Set<PhotoAsset>()
    
    // 九宫格
    func requestImage(for photo: Photo, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        
    }
    
    // 大图
    static func requestImage(for photo: Photo) {
        
    }
    
    static func requestGIF(for photo: Photo) {
        
    }
    
    static func requestLivePhoto(for photo: Photo) {
        
    }
    
    static func requestVideo(for photo: Photo) {
        
    }
    
    
    func read() {
        
    }
    
    func readMore() {
        
    }
    
    func delete() {
        
    }
    
    func image() {
        
    }
    
    func getFile() {
        
    }
    
    
    func download() {
        
    }
    
    // TODO: 列表数据
    // TODO: 选择数据
    //
    // 九宫格展示
    // 大图展示
        
    // TODO: 下载部分可以后台运行 不在这里进行管理
}
