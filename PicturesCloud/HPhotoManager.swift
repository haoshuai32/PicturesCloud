//
//  HPhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

typealias ImageRequestID = PHImageRequestID

protocol HPhotoManager {
    
//    func requestAssets()
//
//    func requestThumbnail(index: Int, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID
//
//    func requestAsset(index: Int)
    
}

// 本地相册管理
struct LocalPhotoManager: HPhotoManager {
    
    private let imageManager = PHCachingImageManager()
    
    private let assets: PHFetchResult<PHAsset>
    
    private var localIdentifier:[String] = []
    
    init() {
        self.assets = PHAsset.fetchAssets(with: nil)
        imageManager.allowsCachingHighQualityImages = false
    }
    
    func requestDataSource()->[PictureSectionModel] {
        
        if self.assets.count <= 0 {
            return []
        }
        
        guard let firstObject = self.assets.firstObject else { return [] }
        
        var list = Array<PictureModel>.init(repeating: PictureModel(asset: firstObject), count: self.assets.count)
        
        assets.enumerateObjects(options: .concurrent) { asset, index, result in
            list[index] = PictureModel(asset: asset)
        }
    
        var result = [PictureSectionModel]()
        let item = PictureSectionModel()
        if let creationDate = firstObject.creationDate {
            item.createData = creationDate
        } else {
            item.createData = Date()
        }
        item.dataSource = list
        result.append(item)
        return result
        
    }
    
    func requestThumbnail(index: Int, targetSize size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        let asset = self.assets[index]
        return imageManager.requestImage(for: asset, targetSize: size, contentMode: .default, options: nil, resultHandler: resultHandler)
    }
    
//    func requestThumbnail(index: Int,targetSize size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
//        if index >= self.assets.count {
//            resultHandler(nil,nil)
//            return 0
//        }
//        return self.requestThumbnail(index: index, targetSize: size, resultHandler: resultHandler)
//    }
    
    // 获取原始数据
    func requestAsset(index: Int) -> Bool {
        
        if index >= self.assets.count {
            return false
        }
        
        let asset = self.assets[index]
        
        let resources = PHAssetResource.assetResources(for: asset)
        
        var datas = Array<Data>.init(repeating: Data(), count: resources.count)
        
        let queue = DispatchQueue(label: "onelcat.github.io.requestAssetData", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        let group = DispatchGroup()
        
        for i in 0..<resources.count {
            group.enter()
            queue.async(group: group, execute: DispatchWorkItem.init(block: {
                let index = i
                let resource = resources[i]
                var itemData = Data()
                PHAssetResourceManager.default().requestData(for: resource, options: nil) { data in
                    itemData.append(data)
                } completionHandler: { error in
                    if let error = error {
                        debugPrint("PHAssetResourceManager requestData error:",error)
                    } else {
                        datas[index] = itemData
                    }
                    group.leave()
                }
            }))
        }
    
        group.notify(queue: queue, work: .init(block: {
            // 返回数据
        }))
        
        return true

    }
    
    func uploadAssets(indexs: [Int]) {
        
    }
    
    func cancelImageRequest(requestID: ImageRequestID) {
        imageManager.cancelImageRequest(requestID)
    }
    
    func startCachingImages(indexs:[Int],targetSize size: CGSize) {
        var assets = [PHAsset]()
        for i in indexs {
            let item = self.assets[i]
            assets.append(item)
        }
        imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImages(indexs:[Int],targetSize size: CGSize) {
        var assets = [PHAsset]()
        for i in indexs {
            let item = self.assets[i]
            assets.append(item)
        }
        imageManager.stopCachingImages(for: assets, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImagesForAllAssets() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
}

//struct CloudPhotoManager: HPhotoManager {
//
//    static let shared = CloudPhotoManager()
//
//    // 获取所有的
//    func requestAssets() {
//
//    }
//
//    func requestThumbnail(index: Int, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
//        return 0
//    }
//
//    func requestAsset(index: Int) {
//
//    }
//}

