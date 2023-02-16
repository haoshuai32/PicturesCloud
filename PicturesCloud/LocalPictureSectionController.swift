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
        switch item.dataSource {
        case let .local(asset):
            LocalPhotoManager.shared.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: nil) { [weak self] image, info in
                guard let image = image,let self = self else {
                    return
                }
                switch item.assetType {
                case .image:
                    <#code#>
                case .gif:
                    <#code#>
                case .live:
                    <#code#>
                case .video(_):
                    <#code#>
                }
    //            case .image:
    //                // photoLive
    //                if asset.mediaSubtypes == .photoLive {
    ////                    resultHandler(.success(.photoLive(image)))
    //                } else
    //                // GIF
    //                if let uniformType = asset.value(forKey: "uniformTypeIdentifier") as? NSString,
    //                    uniformType == "com.compuserve.gif" {
    ////                    resultHandler(.success(.gif(image)))
    //                }
    //                // image
    //                else {
    ////                    resultHandler(.success(.image(image)))
    //                }
    //                break
    //            case .video:
    ////                resultHandler(.success(.video((image,asset.duration))))
    //                break
    //            case .unknown:
    //                fatalError()
    //            case .audio:
    //                fatalError()
    //            @unknown default:
    //                fatalError()
                
            }
            break
        case let .cloud(_):
            break
        }
        
        
//        item.readCoverImage(targetSize: targetSize) { result in
//            switch result {
//            case let .success(resultData):
//                cell.dataSource = resultData
//            case let .failure(error):
//                debugPrint(error.localizedDescription)
//                fatalError()
//
//            }
//        }
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
