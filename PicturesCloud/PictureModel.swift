//
//  PictureModel.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation

enum Status: Int {
    case whole
    case local
    case downloading
    case cloud
    case uploading
}

struct PictureModel {
    
    var localIdentifier: String = ""
    
    var mediaType: PHAssetMediaType = .unknown

    var mediaSubtypes: PHAssetMediaSubtype = .photoHDR

    var pixelWidth: Int = 0

    var pixelHeight: Int = 0

    var creationDate: Date?

    var modificationDate: Date?

    var location: CLLocation?
    
    var duration: Double = 0

}
