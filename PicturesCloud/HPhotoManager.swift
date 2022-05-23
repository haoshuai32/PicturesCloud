//
//  HPhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import Foundation
import Photos
import UIKit

protocol HPhotoManager {
    
    func requestAssets()
    
    func requestThumbnail(index: Int)
    
    func requestAsset(index: Int)
    
}

struct CloudPhotoManager: HPhotoManager {
    
    static let shared = CloudPhotoManager()
    
    // 获取所有的
    func requestAssets() {
        
    }
    
    func requestAlbum(index: Int) ->UIImage? {
        return nil
    }
}

// 本地相册管理
struct LocalPhotoManager: HPhotoManager {

    
    static let shared = LocalPhotoManager()
    
    init() {
        // 本地下载数据
    }
    
    func fetchAssets() {
        // 所有相册
        let all = PHAsset.fetchAssets(with: nil)
        print(all.count)

    }
    
    
    func requestAlbum(index: Int)  {
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        guard let first = result.firstObject else { return }
        // 相册里面的文件夹
        result.enumerateObjects { item, index, result in
            print(item,index,result)
        }
        // 文件夹里面的内容
        let assetResult = PHAsset.fetchAssets(in: first, options: nil)
        
        print(result.count,assetResult.count)
        

        
        return nil
    }
    
}
