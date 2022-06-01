//
//  HDownloadManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos

class HDownloadManager {
    func write() {
        PHPhotoLibrary.shared().performChanges {

            let request = PHAssetCreationRequest()
//            request.location
//            request.creationDate
//            request.isHidden
//            request.isFavorite
            
//            PHAssetCreationRequest.forAsset()
//            let options = PHAssetResourceCreationOptions()
//            options.originalFilename = ""
//            options.shouldMoveFile = false
//            options.uniformTypeIdentifier =
//            request.addResource(with: PHAssetResourceType.alternatePhoto, data: <#T##Data#>, options: PHAssetResourceCreationOptions?)
            
//            PHAssetResourceType(rawValue: <#T##Int#>)
        } completionHandler: { result, error in
            
        }

    }
}
