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
    func equatable() -> Int{
        switch self {
        case .image:
            return 0
        case .gif:
            return 1
        case .live:
            return 2
        case .video(_):
            return 3
        }
    }
}

//extension AssetType: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//
//        switch lhs {
//        case .image:
//
//            break
//        case .gif:
//            break
//        case .live:
//            break
//        case .video(_):
//            break
//        }
//        return false
//    }
//}


enum Asset {
    case local(PHAsset)
    case cloud(Photo)
    
    func data() -> Any {
        switch self {
        case .local(let asset):
            return asset
        case .cloud(let photo):
            return photo
        }
    }
}

class PhotoAsset: ListDiffable, Equatable {

    let identifier: String
    let assetType: AssetType
    let creationDate: Date
    let dataSource: Asset
//    let duration: Double
    init(identifier: String, assetType: AssetType,
         data: Asset, creationDate: Date
//         duration: Double
    ) {
        self.identifier = identifier
        self.assetType = assetType
        self.dataSource = data
        self.creationDate = creationDate
//        self.duration = duration
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
