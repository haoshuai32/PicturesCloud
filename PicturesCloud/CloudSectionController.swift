//
//  CloudSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/7.
//

import IGListKit
import Kingfisher
class CloudSectionController: GridSectionController {
    
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
        
        var itemPhoto: Photo
        switch item.dataSource {
        case .cloud(let photo):
            itemPhoto = photo
            break
        case .local(_):
            fatalError()
            break
        }
 
        cell.imageView.kf.setImage(with: itemPhoto.previewURL)
        
        switch item.assetType {
            
        case .image:
            cell.liveTypeView.isHidden = true
            cell.gifTypeView.isHidden = true
            cell.durationLabel.isHidden = true
        case .video(let duration):
            cell.liveTypeView.isHidden = true
            cell.gifTypeView.isHidden = true
            cell.durationLabel.isHidden = false
            cell.duration = duration
        case .live:
            cell.liveTypeView.isHidden = false
            cell.gifTypeView.isHidden = true
            cell.durationLabel.isHidden = true
            break
        case .gif:
            cell.liveTypeView.isHidden = true
            cell.gifTypeView.isHidden = false
            cell.durationLabel.isHidden = true

        }

        return cell
    }
    
//    private let photoManager = LocalPhotoManager.shared
    // MARK: - ListWorkingRangeDelegate
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
//        self.photoManager.startCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
//        self.photoManager.stopCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    
    
}
