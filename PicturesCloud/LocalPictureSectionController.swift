//
//  LocalSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/24.
//

import UIKit
import IGListKit
import Photos

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
        
        guard let asset = item.dataSource.data() as? PHAsset else {
            fatalError()
        }
        
        _ = LocalPhotoManager.shared.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: nil) { image, info in
            
            guard let image = image else {
                return
            }
            
            switch item.assetType {
            case .image:
                cell.liveTypeView.isHidden = true
                cell.gifTypeView.isHidden = true
                cell.durationLabel.isHidden = true
                cell.imageView.image = image
            case .gif:
                cell.liveTypeView.isHidden = true
                cell.gifTypeView.isHidden = false
                cell.durationLabel.isHidden = true
                cell.imageView.image = image
            case .live:
                cell.liveTypeView.isHidden = false
                cell.gifTypeView.isHidden = true
                cell.durationLabel.isHidden = true
                cell.imageView.image = image
            case .video(let duration):
                cell.liveTypeView.isHidden = true
                cell.gifTypeView.isHidden = true
                cell.durationLabel.isHidden = false
                cell.imageView.image = image
                cell.duration = duration
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
