//
//  Display.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/31.
//

import Foundation
import UIKit
import Photos
import PhotosUI

// 本地和远端 分开

// 只能单独 完成一件事情


//class CloudPHAssetResource {
//    var type: PHAssetResourceType
//    var assetLocalIdentifier: String = ""
//    var uniformTypeIdentifier: String
//    var originalFilename: String
//
//    var fileURL: URL
//}

//class CloudPHAsset {
//    var isInCloud: Bool
//
//    // asset
//    var localIdentifier: String
//    var mediaType: PHAssetMediaType
//    var mediaSubtypes: PHAssetMediaSubtype
//    var pixelWidth: Int
//    var pixelHeight: Int
//    var creationDate: Date?
//    var location: CLLocation?
//    var duration: Double
//    var isFavorite: Bool
//    var isHidden: Bool
//
//    var url: URL
//
//    var resources: [CloudPHAssetResource] = []
//}

// 数据库字段

//protocol HPHAssetResource {
//    var type: PHAssetResourceType { get set}
//    var assetLocalIdentifier: String { get set}
//    var uniformTypeIdentifier: String { get set}
//    var originalFilename: String { get set}
//}


//protocol HPHAsset {
//    var isInCloud: Bool { get set}
//
//    // asset
//    var localIdentifier: String { get set}
//    var mediaType: PHAssetMediaType { get set}
//    var mediaSubtypes: PHAssetMediaSubtype { get set}
//    var pixelWidth: Int { get set}
//    var pixelHeight: Int { get set}
//    var creationDate: Date? { get set}
//    var location: CLLocation? { get set}
//    var duration: Double { get set}
//    var isFavorite: Bool { get set}
//    var isHidden: Bool { get set}
//
//    // resources
//    var resources: [HPHAssetResource] { get set }
//
//    func readAssetCover(targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageID
//
//    func readAssetOriginal()
////
////    func uploadOriginalAsset()
////
////    func downloadOriginalAsset()
//}

typealias ImageID = Int32
import AVFoundation
extension HPHAsset {
    func readAssetOriginal() {
        
//        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [self.identifier], options: nil)
//        guard assets.count == 1, let asset = assets.firstObject else {
//            fatalError()
//            return
//        }
        // image
        
        // local livePhoto
//        PHImageManager.default().requestLivePhoto(for: asset, targetSize: CGSize.zero, contentMode: .default, options: nil) { livePhoto, info in
////            PHLivePhotoFrame
////            let view = PHLivePhotoView()
////            view.livePhoto
//        }
        
        
        
//        // video
//        PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil) { playerItem, info in
////            AVPlayerItem
////            AVPlayerItem.init(url: <#T##URL#>)
////            AVPlayer.init(playerItem: <#T##AVPlayerItem?#>)
//
//        }
        
        // 展示网络数据
        
//        PHLivePhoto.request(withResourceFileURLs: <#T##[URL]#>, placeholderImage: <#T##UIImage?#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, resultHandler: <#T##(PHLivePhoto?, [AnyHashable : Any]) -> Void#>)
        
    }
    func readAssetCover(targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> ImageID {
        
        
//        if isInCloud {
//
//        } else {
//            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [self.identifier], options: nil)
//            guard assets.count == 1, let asset = assets.firstObject else {
//                fatalError()
//                return
//            }
//            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.zero, contentMode: .default, options: nil) { image, info in
//
//            }
//        }
        
        return 0
    }
    
//    func readOriginalAsset() {
//        if isInCloud {
//
//        } else {
//            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [self.identifier], options: nil)
//            guard assets.count == 1, let asset = assets.firstObject else {
//                fatalError()
//                return
//            }
//
//            // image video gif livePhoto
//            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.zero, contentMode: .default, options: nil) { image, info in
//
//            }
//        }
//    }
    
    
}

//class LocalPHAsset: HPHAsset {
//    var isInCloud: Bool = false
////
////    var identifier: String
////
////    var mediaType: PHAssetMediaType
////
////    var mediaSubtypes: PHAssetMediaSubtype
////
////    var pixelWidth: Int
////
////    var pixelHeight: Int
////
////    var creationDate: Date?
////
////    var location: CLLocation?
////
////    var duration: Double
////
////    var isFavorite: Bool
////
////    var isHidden: Bool
////
////    var resources: [HPHAssetResource]
//
//    let asset: PHAsset
//
//    var localIdentifier: String {
//        return asset.localIdentifier
//    }
//    var mediaType: PHAssetMediaType {
//        return asset.mediaType
//    }
//    var mediaSubtypes: PHAssetMediaSubtype {
//        return asset.mediaSubtypes
//    }
//    var pixelWidth: Int {
//        return asset.pixelWidth
//    }
//    var pixelHeight: Int {
//        return asset.pixelHeight
//    }
//    var creationDate: Date? {
//        return asset.creationDate
//    }
//    var location: CLLocation? {
//        return asset.location
//    }
//    var duration: Double {
//        return asset.duration
//    }
//    var isFavorite: Bool {
//        return asset.isFavorite
//    }
//    var isHidden: Bool {
//        return asset.isHidden
//    }
//
//    init(asset: PHAsset) {
//
//    }
//
//}


//class LocalAsset {
//    let asset: PHAsset
//    let resources: [PHAssetResource]
//}
//
//class CloudAsset {
//
//}

//class DisplayAsset {
//    let isInCloud: Bool
//    let asset: HPHAsset
//    var sesource: [HPHAssetResource] = []
//}

import IGListDiffKit

typealias HPHAssetMediaType = PHAssetMediaType
typealias HPHAssetMediaSubtype = PHAssetMediaSubtype
typealias HPHAssetResourceType = PHAssetResourceType

class DisplayAssetResource {
    
    let type: HPHAssetResourceType
    let assetIdentifier: String
    let uniformTypeIdentifier: String
    let originalFilename: String
    let fileURL: URL?
    let resource: PHAssetResource?
    
    convenience init(resource: PHAssetResource) {
        self.init(type: resource.type, assetIdentifier: resource.assetLocalIdentifier, uniformTypeIdentifier: resource.uniformTypeIdentifier, originalFilename: resource.originalFilename, fileURL: nil, resource: resource)
    }
    
    required init(type: HPHAssetResourceType,
         assetIdentifier: String,
         uniformTypeIdentifier: String,
         originalFilename: String,
         fileURL: URL?,
         resource: PHAssetResource?) {
        self.type = type
        self.assetIdentifier = assetIdentifier
        self.uniformTypeIdentifier = uniformTypeIdentifier
        self.originalFilename = originalFilename
        self.fileURL = fileURL
        self.resource = resource
    }
}

typealias HPHAsset = PHAsset

class DisplayAsset {
    
    let identifier: String
    let mediaType: HPHAssetMediaType
    let mediaSubtypes: HPHAssetMediaSubtype
    let pixelWidth: Int
    let pixelHeight: Int
    let creationDate: Date?
    let location: CLLocation?
    let duration: Double
    let isFavorite: Bool
    let isHidden: Bool
    
    var isInCloud: Bool
    let imageURL: URL?
    let asset: HPHAsset?
    
    var resources: [DisplayAssetResource] = []
    
    required init(identifier: String,
                  mediaType: HPHAssetMediaType,
                  mediaSubtypes: HPHAssetMediaSubtype,
                  pixelWidth: Int,
                  pixelHeight: Int,
                  creationDate: Date?,
                  location: CLLocation?,
                  duration: Double,
                  isFavorite: Bool,
                  isHidden: Bool,
                  isInCloud: Bool,
                  imageURL: URL?,
                  asset: HPHAsset?) {
        self.identifier = identifier
        self.mediaType = mediaType
        self.mediaSubtypes = mediaSubtypes
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.creationDate = creationDate
        self.location = location
        self.duration = duration
        self.isFavorite = isFavorite
        self.isHidden = isHidden
        self.isInCloud = isInCloud
        self.imageURL = imageURL
        self.asset = asset
    }
    
    convenience init(asset: HPHAsset) {
        self.init(identifier: asset.localIdentifier, mediaType: asset.mediaType, mediaSubtypes: asset.mediaSubtypes, pixelWidth: asset.pixelWidth, pixelHeight: asset.pixelHeight, creationDate: asset.creationDate, location: asset.location, duration: asset.duration, isFavorite: asset.isFavorite, isHidden: asset.isHidden, isInCloud: false, imageURL: nil, asset: asset)
    }
        
}

extension DisplayAsset: Equatable {
    static func == (lhs: DisplayAsset, rhs: DisplayAsset) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension DisplayAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(mediaType)
    }
}

extension DisplayAsset: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? LocalPictureModel else { return false }
        return identifier == object.identifier
    }
}

//struct {
//
//}



// read
import Kingfisher

extension DisplayAsset {
    
    enum AssetOriginalData {
        case image(UIImage)
        case photoLive(PHLivePhoto)
        case gif((Data,String))
        case video(AVPlayerItem)
    }
    
    enum AssetCoverImage {
        case image(UIImage)
        case photoLive(UIImage)
        case gif(UIImage)
        case video((UIImage,Double))
    }
    
    func photoManager() -> LocalPhotoManager {
        return LocalPhotoManager.shared
    }
    
    func readCoverImage(targetSize size: CGSize, resultHandler: @escaping (Result<AssetCoverImage,Error>) -> Void) -> ImageID {
        if let asset = self.asset {
            return photoManager().requestImage(for: asset, targetSize: size, contentMode: .default, options: nil) { [weak self] image, info in
                guard let image = image,let self = self else {
                    return
                }
                switch asset.mediaType {
                case .image:
                    // photoLive
                    if asset.mediaSubtypes == .photoLive {
                        resultHandler(.success(.photoLive(image)))
                    } else
                    // GIF
                    if let uniformType = asset.value(forKey: "uniformTypeIdentifier") as? NSString,
                        uniformType == "com.compuserve.gif" {
                        resultHandler(.success(.gif(image)))
                    }
                    // image
                    else {
                        resultHandler(.success(.image(image)))
                    }
                    break
                case .video:
                    resultHandler(.success(.video((image,asset.duration))))
                    break
                case .unknown:
                    fatalError()
                case .audio:
                    fatalError()
                @unknown default:
                    fatalError()
                }
            }

        } else if isInCloud == true,let url = self.imageURL {
            
           let task = KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
               guard let self = self else {
                   return
               }
                switch result {
                case let .success(imageResult):
                    let image = imageResult.image
                    switch self.mediaType {
                    case .image:
                        // photoLive
                        if self.mediaSubtypes == .photoLive {
                            resultHandler(.success(.photoLive(image)))
                        } else
                        // GIF
                        if self.mediaSubtypes.rawValue == 64 {
                            resultHandler(.success(.gif(image)))
                        }
                        // image
                        else {
                            resultHandler(.success(.image(image)))
                        }
                        break
                    case .video:
                        resultHandler(.success(.video((image,self.duration))))
                        break
                    case .unknown:
                        fatalError()
                    case .audio:
                        fatalError()
                    @unknown default:
                        fatalError()
                    }
                    break
                case let .failure(error):
                    resultHandler(.failure(error))
                    break
                }
            }
            
            return 0
        } else {
            fatalError()
        }
    }
    
    func readOriginal(resultHandler: @escaping (Result<AssetOriginalData,Error>) -> Void) {
        if let asset = self.asset {
            switch mediaType {
            case .image:
                // photoLive
                if mediaSubtypes == .photoLive {
                    PHImageManager.default().requestLivePhoto(for: asset, targetSize: CGSize.zero, contentMode: .default, options: nil) { livePhoto, info in
                        guard let livePhoto = livePhoto else {
                            fatalError()
                        }
                        resultHandler(.success(.photoLive(livePhoto)))
                    }
                } else
                // GIF
                if let uniformType = asset.value(forKey: "uniformTypeIdentifier") as? NSString,
                    uniformType == "com.compuserve.gif" {
                    let resources = PHAssetResource.assetResources(for: asset)
                    guard resources.count == 1,let gifResource = resources.first else {
                        fatalError()
                    }
                    var resultData = Data()
                    PHAssetResourceManager.default().requestData(for: gifResource, options: nil) { data in
                        resultData.append(data)
                    } completionHandler: { error in
                        if let error = error {
                            resultHandler(.failure(error))
                        } else {
                            
                            var nameEx:[String] = gifResource.originalFilename.split(separator: ".").map{String($0)}
                            nameEx[0] = gifResource.assetLocalIdentifier.replacingOccurrences(of: "/", with: "_")
                            let key = nameEx.joined(separator: ".")
                            
                            resultHandler(.success(.gif((resultData,key))))
                            
//                            let souce = KFCrossPlatformImage.init(data: resultData)!
//                            UIImageView().kf.setImage(with: RawImageDataProvider(data: resultData, cacheKey: key))
                            
                        }
                    }
                }
                // image
                else {
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize.zero, contentMode: .default, options: nil) { image, info in
                        
                        guard let image = image else {
                            fatalError()
                            return
                        }
                        resultHandler(.success(.image(image)))
                    }
                }
                break
            case .video:
                PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil) { playItem, info in
                    guard let playerItem = playItem else {
                        fatalError()
                        return
                    }
                    resultHandler(.success(.video(playerItem)))
                }
                break
            default:
                break
            }
        } else if isInCloud == true {
            
            // TODO: 读取 resource
            let resources = self.resources
            switch self.mediaType {
            case .image:
                // photoLive
                if self.mediaSubtypes == .photoLive {
                    
//                    let request = URLRequest(url: <#T##URL#>)
//                    URLSession.shared.downloadTask(with: <#T##URLRequest#>) { <#URL?#>, <#URLResponse?#>, <#Error?#> in
//                        <#code#>
//                    }
                    
                    // 存在两条数据
                    // 需要先吧数据下载下来
                    
                    
                } else
                // GIF
                if self.mediaSubtypes.rawValue == 64 {
                    // gif 存在一条数据
                    guard let gifURL = resources.first?.fileURL else {
                        fatalError()
                        return
                    }
                    KingfisherManager.shared.downloader.downloadImage(with: gifURL, options: KingfisherParsedOptionsInfo.init(nil)) { result in
                        switch result {
                        case let .success(imageResult):
                            resultHandler(.success(.gif((imageResult.originalData,gifURL.absoluteString))))
                            break
                        case let .failure(error):
                            resultHandler(.failure(error))
                            break
                        }
                    }
                }
                // image
                else {
                    // 看是否存在多条数据
                    guard let imageURL = resources.first?.fileURL else {
                        fatalError()
                        return
                    }
                    KingfisherManager.shared.downloader.downloadImage(with: imageURL, options: KingfisherParsedOptionsInfo.init(nil)) { result in
                        switch result {
                        case let .success(imageResult):
                            resultHandler(.success(.image(imageResult.image)))
                            break
                        case let .failure(error):
                            resultHandler(.failure(error))
                            break
                        }
                    }
                }
                break
            case .video:
                guard let videoURL = resources.first?.fileURL else {
                    fatalError()
                    return
                }
                let playerItem = AVPlayerItem(url: videoURL)
                resultHandler(.success(.video(playerItem)))
                break
            default:
                break
            }
            
            
//            return -1
        } else {
            fatalError()
        }
    }
}


extension DisplayAsset {
    
    func readAssetData() {
        
    }
    
    func upload() {
        
    }
    
}

extension DisplayAsset {
    
    func download() {
        
    }
    
    func writeOriginalAssetData() {
        
    }
    
}

