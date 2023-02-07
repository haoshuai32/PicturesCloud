//
//  CloudSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/7.
//

import IGListKit

class CloudSectionController: GridSectionController {
    
//    private let photoManager = LocalPhotoManager.shared
    // MARK: - ListWorkingRangeDelegate
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
//        self.photoManager.startCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
//        self.photoManager.stopCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
}
