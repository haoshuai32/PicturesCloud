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

class LocalPictureModel {
    
    let asset: PHAsset
    
    let identifier: String
    
    let mediaType: PHAssetMediaType

    let mediaSubtypes: PHAssetMediaSubtype

    let pixelWidth: Int

    let pixelHeight: Int

    let creationDate: Date?

    let location: CLLocation?
    
    let duration: Double
    
    // Resource
    var assetResource:[PHAssetResource] = []
    
    init(asset: PHAsset) {
        self.asset = asset
        identifier = asset.localIdentifier
        creationDate = asset.creationDate
        mediaSubtypes = asset.mediaSubtypes
        mediaType = asset.mediaType
        pixelWidth = asset.pixelWidth
        pixelHeight = asset.pixelHeight
        duration = asset.duration
        location = asset.location
    }
    
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
