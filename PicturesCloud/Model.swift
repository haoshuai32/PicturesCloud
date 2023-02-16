//
//  Model.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/16.
//

import Foundation
import CoreLocation

typealias CloudAsset = Photo


struct ViewAsset<T> {
    
    let asset: T?
    
    var isInCloud: Bool
    
}
