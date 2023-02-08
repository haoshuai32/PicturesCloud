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
        
        cell.imageView.kf.setImage(with: item.imageURL)
        
        switch item.mediaType {
            
        case .unknown:
            break
        case .image:
            if item.mediaSubtypes == .photoLive {
                cell.liveTypeView.isHidden = false
                cell.gifTypeView.isHidden = true
                cell.durationLabel.isHidden = true
            } else {
                cell.liveTypeView.isHidden = true
                cell.gifTypeView.isHidden = true
                cell.durationLabel.isHidden = true
                
            }
        case .video:
            cell.liveTypeView.isHidden = true
            cell.gifTypeView.isHidden = true
            cell.durationLabel.isHidden = false

            cell.duration = item.duration
        case .audio:
            cell.liveTypeView.isHidden = true
            cell.gifTypeView.isHidden = false
            cell.durationLabel.isHidden = true

        @unknown default:
            break
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
