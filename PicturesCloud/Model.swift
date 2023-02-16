//
//  Model.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/16.
//

import Foundation
import CoreLocation

typealias CloudAsset = Photo


enum PhotoAssetType {
    case image
    case gif
    case live
    case video(Double)
}

protocol PhotoAsset {
    var identifier: String {set get}
    var photoType: PhotoAssetType  {set get}
    var pixelWidth: Int {set get}
    var pixelHeight: Int {set get}
    var creationDate: Date? {set get}
    var location: CLLocation? {set get}
    var duration: Double {set get}
}


struct LocalViewAsset: PhotoAsset {
    
}

struct CloudViewAsset: PhotoAsset {
    
}





//struct ViewAsset<T> {
//
//    let asset: T?
//
//    let isCloud: Bool
//
//}
