//
//  PictureModel.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import IGListDiffKit

enum Status: Int {
    case whole
    case local
    case downloading
    case cloud
    case uploading
}

class PictureModel {
    
    let asset: PHAsset
    
    let identifier: String
    
    let mediaType: PHAssetMediaType

    let mediaSubtypes: PHAssetMediaSubtype

    let pixelWidth: Int

    let pixelHeight: Int

    let creationDate: Date?

    let modificationDate: Date?

    let location: CLLocation?
    
    let duration: Double
    
    // Resource
    var cloudImageURL: URL?
    
    var cloudURL: URL?

    var uti: String = ""
    
    var fileName: String = ""
    
    var fileURL: String = ""
    
    var fileSize: Int = 0
    
    var assetResource:[PHAssetResource] = []
    
    init(asset: PHAsset) {
        self.asset = asset
        identifier = asset.localIdentifier
        creationDate = asset.creationDate
        mediaSubtypes = asset.mediaSubtypes
        mediaType = asset.mediaType
        modificationDate = asset.modificationDate
        pixelWidth = asset.pixelWidth
        pixelHeight = asset.pixelHeight
        duration = asset.duration
        location = asset.location
    }
    
}

//class Picture

extension PictureModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? PictureModel else { return false }
        return identifier == object.identifier && uti == object.uti
    }
    
}

class PictureSectionModel {
    var createData: Date = Date()
    var dataSource: [PictureModel] = []
}

extension PictureSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return createData as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? PictureSectionModel else { return false }
        return object.createData.timeIntervalSince1970 == createData.timeIntervalSince1970
    }
}
