//
//  Model.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/16.
//

import Foundation
import IGListDiffKit
import Photos

enum AssetType {
    case image
    case gif
    case live
    case video(Double)
}

extension AssetType: Equatable {
    
}


enum Asset {
    case local(PHAsset)
    case cloud(Photo)
}

class PhotoAsset: ListDiffable, Equatable {

    let identifier: String
    let assetType: AssetType
    let creationDate: Date
    let dataSource: Asset
    
    init(identifier: String, assetType: AssetType,
         data: Asset, creationDate: Date) {
        self.identifier = identifier
        self.assetType = assetType
        self.dataSource = data
        self.creationDate = creationDate
    }
    
}

extension PhotoAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
//        hasher.combine(assetType)
    }
}

extension PhotoAsset {
    
    static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}

extension PhotoAsset {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? (PhotoAsset) else { return false }
        return identifier == object.identifier
    }
    
}
