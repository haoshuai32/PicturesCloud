//
//  PhotoManager.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/22.
//

import Foundation



protocol AssetManager {
    associatedtype T
    // dataSource
    var dataSource: [PhotoAsset] {set get}
    var selectDataSource: Set<PhotoAsset> {set get}

    // selectDataSource

    func read()
    func readMore()
    func delete()
    func image()
    func getFile()
    // reload()

    // loadmore()



    // 选择的数据

    // 获取照片

    // 缓存照片

    // 显示大照片
    

}
