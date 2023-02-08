//
//  LocalSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/24.
//

import UIKit
import IGListKit

class LocalSectionController: GridSectionController {
    
    private let photoManager = LocalPhotoManager.shared
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext!.dequeueReusableCell(withNibName: "GridCell", bundle: nil, for: self, at: index) as? GridCell else {
            fatalError()
        }
        
        let item = self.dataSource[index]
        if self.selectedData.contains(item) {
            cell.selelctButton.isSelected = true
        } else {
            cell.selelctButton.isSelected = false
        }

        // add tag
        cell.selelctButton.tag = index
        cell.selelctButton.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)
        
        item.readCoverImage(targetSize: targetSize) { result in
            switch result {
            case let .success(resultData):
                cell.dataSource = resultData
            case let .failure(error):
                debugPrint(error.localizedDescription)
                fatalError()
                
            }
        }
        return cell
    }
    
    // MARK: - ListWorkingRangeDelegate
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        self.photoManager.startCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
        self.photoManager.stopCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
}
