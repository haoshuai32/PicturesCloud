//
//  LocalPhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/9.
//

import Foundation
import Photos
import UIKit

class LocalAssetManager: NSObject,AssetManager, PHPhotoLibraryChangeObserver {
    
    typealias T = PHAsset
    
    var dataSource: [PhotoAsset] = []
    
    var selectDataSource: Set<PhotoAsset> = Set<PhotoAsset>()
    
    private let imageManager = PHCachingImageManager()
    
    private var assets: PHFetchResult<PHAsset>
    
    private static func loadDataSource(_ assets: PHFetchResult<PHAsset>) -> [PhotoAsset] {
        
        guard let firstObject = assets.firstObject else {
            return []
        }
        
        let item = PhotoAsset(identifier: firstObject.localIdentifier, assetType: .image, data: .local(firstObject), creationDate: firstObject.creationDate ?? Date())
        
        var list = Array<PhotoAsset>.init(repeating: item, count: assets.count)
        
        assets.enumerateObjects(options: .concurrent) { asset, index, result in
            switch asset.mediaType {
            case .image:
                // photoLive
                if asset.mediaSubtypes == .photoLive {
                    list[index] = PhotoAsset(identifier: asset.localIdentifier, assetType: .live, data: .local(asset), creationDate: asset.creationDate ?? Date())
                } else
                // GIF
                if let uniformType = asset.value(forKey: "uniformTypeIdentifier") as? NSString,
                    uniformType == "com.compuserve.gif" {
                    list[index] = PhotoAsset(identifier: asset.localIdentifier, assetType: .gif, data: .local(asset), creationDate: asset.creationDate ?? Date())
                }
                // image
                else {
                    list[index] = PhotoAsset(identifier: asset.localIdentifier, assetType: .image, data: .local(asset), creationDate: asset.creationDate ?? Date())
                }
            case .video:
                list[index] = PhotoAsset(identifier: asset.localIdentifier, assetType: .video(asset.duration), data: .local(asset), creationDate: asset.creationDate ?? Date())
            case .unknown:
                fatalError()
            case .audio:
                fatalError()
            @unknown default:
                fatalError()
            }
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
    
    func requestDataSource(_ type: Int = 0)->[PhotoAsset] {
        
        if self.dataSource.count <= 0 {
            return []
        }
        
        var list = [PhotoAsset]()
        switch type {
        case 0:
            list = self.dataSource
            break
        case 1:
            list = self.dataSource.filter{$0.assetType.equatable() == AssetType.video(0).equatable()}
            break
        case 2:
            list = self.dataSource.filter{$0.assetType.equatable() == AssetType.image.equatable()}
            break
        default:
            fatalError()
        }
        
        return list
        
    }
    
    
    
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageRequestID {
        return imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler)
    }
    
    func requestImage() {
        
    }
    
    func requestGIF() {
        
    }
    
    func requestLivePhoto() {
        
    }
    
    func requestVideo() {
        
    }
    
    func startCachingImages(assets:[PhotoAsset],targetSize size: CGSize) {
        let data = assets.compactMap{$0.dataSource}
        let list = data.compactMap { item in
            switch item {
            case .local(let asset):
                return asset
                break
            case .cloud(_):
                fatalError()
            }
        }
        imageManager.startCachingImages(for: list, targetSize: size, contentMode: .default, options: nil)
    }
    
    func stopCachingImages(assets:[PhotoAsset],targetSize size: CGSize) {
        let data = assets.compactMap{$0.dataSource}
        let list = data.compactMap { item in
            switch item {
            case .local(let asset):
                return asset
                break
            case .cloud(_):
                fatalError()
            }
        }
        imageManager.stopCachingImages(for: list, targetSize: size, contentMode: .default, options: nil)
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
    
    func upload() {
        
    }
    
    
    static func createPhotoLiveAsset(lievPhoto:(imgPath:URL,movPath:URL), completionHandler: @escaping ((Bool, Error?) -> Void)){
        PHPhotoLibrary.shared().performChanges({

            let options = PHAssetResourceCreationOptions()
            let request = PHAssetCreationRequest.forAsset()
            
            request.addResource(with: .photo, fileURL: lievPhoto.imgPath, options: options)
            request.addResource(with: .pairedVideo, fileURL: lievPhoto.movPath, options: options)
          
        },completionHandler: completionHandler)
    }
    
    static func createPhotoLiveAsset(lievPhoto:(imgData:Data,movData:Data), completionHandler: @escaping ((Bool, Error?) -> Void)) {
                
        let imgPath = HFileManager.shared.tempImg
        let movPath = HFileManager.shared.tempMov
        do {
            try lievPhoto.imgData.write(to: imgPath)
            try lievPhoto.movData.write(to: movPath)
            Self.createPhotoLiveAsset(lievPhoto: (imgPath: imgPath, movPath: movPath), completionHandler: completionHandler)
            
        } catch let error {
            
        }
        
        
    }
    
    static func createFileAsset(data: Data, completionHandler: @escaping ((Bool, Error?) -> Void)) {
        // 把数据保存到文件中
        let tempPath = HFileManager.shared.tempFile
        do {
            try data.write(to: tempPath)
            Self.createFileAsset(file: tempPath, completionHandler: completionHandler)
        } catch let error {
            
        }
        
        
    }
    
    
    static func createFileAsset(file: URL, completionHandler: @escaping ((Bool, Error?) -> Void)) {
        
    }
    
    // TODO: 上传部分可以后台运行 不在这里进行管理
    
    // 列表数据
    // 选择数据
    
    // 加载一次
    // 加载更多
    // 删除
    
    
    // 数据是否需要刷新
    
    // 九宫格 展示
    // 大图展示
    
    
}




