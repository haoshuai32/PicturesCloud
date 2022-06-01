//
//  PictureModel.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import IGListDiffKit

//class HPHAsset {
//    
//    let asset: PHAsset
//  
//    var identifier: String {
//        return asset.localIdentifier
//    }
//
//    var mediaType: PHAssetMediaType {
//        return asset.mediaType
//    }
//    
//    var mediaSubtypes: PHAssetMediaSubtype {
//        return asset.mediaSubtypes
//    }
//
//    var pixelWidth: Int {
//        return asset.pixelWidth
//    }
//
//    var pixelHeight: Int {
//        return asset.pixelHeight
//    }
//
//    var creationDate: Date? {
//        return asset.creationDate
//    }
//
//    var location: CLLocation? {
//        return asset.location
//    }
//
//    var duration: Double {
//        return asset.duration
//    }
//    
//    // Resource
//    var assetResource:[PHAssetResource] = []
//    
//    init(asset: PHAsset) {
//        self.asset = asset
//    }
//    
//    // 读取本地封面
//    
//    // 读取所有的资源数据
//    
//    // 上传数据
//    
//}

//extension HPHAsset: Equatable {
//    static func == (lhs: HPHAsset, rhs: HPHAsset) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//}
//
//extension HPHAsset: Hashable {
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(identifier)
//        hasher.combine(mediaType)
//    }
//}

class LocalPictureModel {
    
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

extension LocalPictureModel: Equatable {
    static func == (lhs: LocalPictureModel, rhs: LocalPictureModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension LocalPictureModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(mediaType)
    }
}



//class Picture

extension LocalPictureModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? LocalPictureModel else { return false }
        return identifier == object.identifier
    }
    
}

class LocalPictureSectionModel {
    var createData: Date = Date()
    var dataSource: [LocalPictureModel] = []
}

extension LocalPictureSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return createData as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? LocalPictureSectionModel else { return false }
        return object.createData.timeIntervalSince1970 == createData.timeIntervalSince1970
    }
}
