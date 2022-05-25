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

protocol PhotoManagerChangeDelegate:class {
    func photoDidChange()
}

// 本地相册管理
class LocalPhotoManager: NSObject, HPhotoManager, PHPhotoLibraryChangeObserver {

    private let imageManager = PHCachingImageManager()
    
    private var assets: PHFetchResult<PHAsset>
    
    weak var changeDelegate: PhotoManagerChangeDelegate?
    
    override init() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.assets = PHAsset.fetchAssets(with: fetchOptions)
        
        super.init()
        
        imageManager.allowsCachingHighQualityImages = true
        
        PHPhotoLibrary.shared().register(self)
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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
    
    func requestThumbnail(picture: PictureModel, targetSize size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        let asset = picture.asset
        return imageManager.requestImage(for: asset, targetSize: size, contentMode: .default, options: nil, resultHandler: resultHandler)
    }
    
    // 获取原始数据
    func requestAsset(picture: PictureModel) -> Bool {
        
        let asset = picture.asset
        
        let resources = PHAssetResource.assetResources(for: asset)
        picture.assetResource = resources
        
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
    
    func startCachingImages(pictures:[PictureModel],targetSize size: CGSize) {
        let assets = pictures.map{$0.asset}
        imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImages(pictures:[PictureModel],targetSize size: CGSize) {
        let assets = pictures.map{$0.asset}
        imageManager.stopCachingImages(for: assets, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImagesForAllAssets() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    // MARK: - PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.assets) else {
            return
        }
        let assets = changes.fetchResultAfterChanges
        self.assets = assets
        
        // TODO: 后续实现增量更新数据
        
        print("change photo",self.assets.count, assets.count)
        if changes.hasIncrementalChanges {

            self.changeDelegate?.photoDidChange()

            if let removed = changes.removedIndexes, removed.count > 0 {

                let removedIndexs = removed.map{$0 as Int}

                print("removedIndexs assets",removed)
            }

            if let inserted = changes.insertedIndexes , inserted.count > 0 {
//                                    collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
                let insertedIndexs = inserted.map{$0 as Int}
                print("insertedIndexs assets",insertedIndexs)
            }

            if let changed = changes.changedIndexes , changed.count > 0 {
                let changedIndexs = changed.map{$0 as Int}
//                                    collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
                print("changedIndexs assets",changedIndexs)
            }

            changes.enumerateMoves { fromIndex, toIndex in
//                                    collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                            to: IndexPath(item: toIndex, section: 0))

            }

        }
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

