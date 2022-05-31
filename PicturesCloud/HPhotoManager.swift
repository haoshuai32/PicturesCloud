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
    
}

protocol PhotoManagerChangeDelegate:class {
    func photoDidChange()
}

// 本地相册管理
class LocalPhotoManager: NSObject, HPhotoManager, PHPhotoLibraryChangeObserver {

    private let imageManager = PHCachingImageManager()
    
    private var assets: PHFetchResult<PHAsset>
    
    private var dataSource: [LocalPictureModel] = []
    
    weak var changeDelegate: PhotoManagerChangeDelegate?
    
    private func loadDataSource(_ assets: PHFetchResult<PHAsset>) {
        guard let firstObject = assets.firstObject else {
            self.dataSource = []
            return
        }
        
        var list = Array<LocalPictureModel>.init(repeating: LocalPictureModel(asset: firstObject), count: assets.count)
        assets.enumerateObjects(options: .concurrent) { asset, index, result in
            list[index] = LocalPictureModel(asset: asset)
        }
        self.dataSource = list
    }
    
    override init() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.assets = PHAsset.fetchAssets(with: fetchOptions)
        super.init()
        loadDataSource(self.assets)
        imageManager.allowsCachingHighQualityImages = true
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func requestDataSource(_ type: Int = 0)->[LocalPictureSectionModel] {
        
        if self.dataSource.count <= 0 {
            return []
        }
        var result = [LocalPictureSectionModel]()
        let item = LocalPictureSectionModel()
        var list = [LocalPictureModel]()
        switch type {
        case 0:
            list = self.dataSource
            break
        case 1:
            list = self.dataSource.filter{$0.mediaType == .video}
            break
        case 2:
            list = self.dataSource.filter{$0.mediaType == .image}
            break
        default:
            fatalError()
        }
        
        if let creationDate = list.first?.creationDate {
            item.createData = creationDate
        } else {
            item.createData = Date()
        }
        item.dataSource = list
        result.append(item)
        return result
        
    }
    
    func requestThumbnail(picture: LocalPictureModel, targetSize size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        let asset = picture.asset
        return imageManager.requestImage(for: asset, targetSize: size, contentMode: .default, options: nil, resultHandler: resultHandler)
    }
    
    func requestImage(picture: LocalPictureModel, targetSize size: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        let asset = picture.asset
        return imageManager.requestImage(for: asset, targetSize: size, contentMode: .default, options: nil, resultHandler: resultHandler)
    }
    
    // 获取原始数据
    static func requestAssetData(picture: LocalPictureModel, resultHandler: @escaping (_ result:Result<[Data],Error>)->Void) -> Bool {
        
        let asset = picture.asset
        
        let resources = PHAssetResource.assetResources(for: asset)
        picture.assetResource = resources
        
        var resultData = Array<Data>.init(repeating: Data(), count: resources.count)
        
        let queue = DispatchQueue(label: "onelcat.github.io.requestAssetData", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        let group = DispatchGroup()
        var resultError: Error?
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
                        resultError = error
                        debugPrint("PHAssetResourceManager requestData error:",error)
                    } else {
                        resultData[index] = itemData
                    }
                    group.leave()
                }
            }))
        }
    
        group.notify(queue: queue, work: .init(block: {
            // 返回数据
            if let error = resultError {
                resultHandler(.failure(error))
            } else {
                resultHandler(.success(resultData))
            }
            
        }))
        
        return true

    }
    
    func uploadAssets(indexs: [Int]) {
        
    }
    
    func cancelImageRequest(requestID: ImageRequestID) {
        imageManager.cancelImageRequest(requestID)
    }
    
    func startCachingImages(pictures:[LocalPictureModel],targetSize size: CGSize) {
        let assets = pictures.map{$0.asset}
        imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImages(pictures:[LocalPictureModel],targetSize size: CGSize) {
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
        self.loadDataSource(assets)
        
        // TODO: 后续实现增量更新数据
        
        print("change photo",self.assets.count, assets.count)
        if changes.hasIncrementalChanges {

            self.changeDelegate?.photoDidChange()

            if let removed = changes.removedIndexes, removed.count > 0 {

                let removedIndexs = removed.map{$0 as Int}

                print("removedIndexs assets",removed)
            }

            
            
            if let inserted = changes.insertedIndexes , inserted.count > 0 {
                let insertedIndexs = inserted.map{$0 as Int}
                print("insertedIndexs assets",insertedIndexs)
            }

            if let changed = changes.changedIndexes , changed.count > 0 {
                let changedIndexs = changed.map{$0 as Int}
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

