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

//protocol PhotoChangeDelegate:class {
//    func photoDidChange()
//}

// 本地相册管理
class LocalPhotoManager: NSObject, HPhotoManager, PHPhotoLibraryChangeObserver {

    static let shared = LocalPhotoManager()
    
    private let imageManager = PHCachingImageManager()
    
    private var assets: PHFetchResult<PHAsset>
    
    private var dataSource: [PhotoAsset] = []
    
    private static func loadDataSource(_ assets: PHFetchResult<PHAsset>) -> [PhotoAsset] {
        
        guard let firstObject = assets.firstObject else {
            return []
        }
        
        let item = PhotoAsset(identifier: firstObject.localIdentifier, assetType: .image, data: .local(firstObject), creationDate: firstObject.creationDate ?? Date())
        
        var list = Array<PhotoAsset>.init(repeating: item, count: assets.count)
        
        assets.enumerateObjects(options: .concurrent) { asset, index, result in
            
            
            
            list[index] = PhotoAsset(identifier: asset.localIdentifier, assetType: .image, data: .local(asset), creationDate: asset.creationDate ?? Date())
            
        }
        return list
    }
    
    override init() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.assets = PHAsset.fetchAssets(with: fetchOptions)
        super.init()
        self.dataSource = Self.loadDataSource(self.assets)
        imageManager.allowsCachingHighQualityImages = true
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func requestDataSource(_ type: Int = 0)->[DisplayAsset] {
        
        if self.dataSource.count <= 0 {
            return []
        }
        
        var list = [DisplayAsset]()
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
        
        return list
        
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        return imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler)
    }
    
    func startCachingImages(assets:[DisplayAsset],targetSize size: CGSize) {
        let data = assets.compactMap{$0.asset}
        imageManager.startCachingImages(for: data, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImages(assets:[DisplayAsset],targetSize size: CGSize) {
        let data = assets.compactMap{$0.asset}
        imageManager.stopCachingImages(for: data, targetSize: size, contentMode: .default, options: nil)
    }
    
    func cancelImageRequest(requestID: ImageRequestID) {
        imageManager.cancelImageRequest(requestID)
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
        self.dataSource = Self.loadDataSource(assets)
        
        // TODO: 后续实现增量更新数据
        
//        print("change photo",self.assets.count, assets.count)
        if changes.hasIncrementalChanges {

            if let removed = changes.removedIndexes, removed.count > 0 {

                let removedIndexs = removed.map{$0 as Int}
                
                NotificationCenter.default.post(name: NSNotification.Name.PhotoLibraryChange.Removed, object: removedIndexs, userInfo: nil)
                
//                print("removedIndexs assets",removed)
            }

            
            
            if let inserted = changes.insertedIndexes , inserted.count > 0 {
                let insertedIndexs = inserted.map{$0 as Int}
                NotificationCenter.default.post(name: NSNotification.Name.PhotoLibraryChange.Inserted, object: insertedIndexs, userInfo: nil)
//                print("insertedIndexs assets",insertedIndexs)
            }

            if let changed = changes.changedIndexes , changed.count > 0 {
                let changedIndexs = changed.map{$0 as Int}
                NotificationCenter.default.post(name: NSNotification.Name.PhotoLibraryChange.Changed, object: changedIndexs, userInfo: nil)
//                print("changedIndexs assets",changedIndexs)
            }

            changes.enumerateMoves { fromIndex, toIndex in
                NotificationCenter.default.post(name: NSNotification.Name.PhotoLibraryChange.Moves, object: (fromIndex,toIndex), userInfo: nil)
//                                    collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                            to: IndexPath(item: toIndex, section: 0))

            }

        }
    }
    
}

extension NSNotification.Name {
    struct PhotoLibraryChange {
        static let Removed = Notification.Name("onelcat.github.io.PhotoLibraryChange.Removed")
        static let Inserted = Notification.Name("onelcat.github.io.PhotoLibraryChange.Inserted")
        static let Changed = Notification.Name("onelcat.github.io.PhotoLibraryChange.Changed")
        static let Moves = Notification.Name("onelcat.github.io.PhotoLibraryChange.Moves")
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

