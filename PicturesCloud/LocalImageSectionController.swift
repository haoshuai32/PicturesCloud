//
//  LocalImageSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/25.
//

import UIKit
import IGListKit

class LocalImageSectionController: ListSectionController,
                                   ListWorkingRangeDelegate {
    
    private let photoManager: LocalPhotoManager
    
    private var dataSource: LocalPictureModel?
    
    private var requestImage: UIImage?
    
    private
    lazy var itemSize: CGSize = {
        return UIScreen.main.bounds.size
    }()
    
    required init(manager: LocalPhotoManager) {
        self.photoManager = manager
        super.init()
        workingRangeDelegate = self
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return itemSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        print("cellForItem index",index)
        guard let cell = collectionContext!.dequeueReusableCell(withNibName: "LocalImageCell", bundle: nil, for: self, at: index) as? LocalImageCell else {
            fatalError()
        }
        cell.image = self.requestImage
        return cell
    }
    
    override func didUpdate(to object: Any) {
        if let data = object as? LocalPictureModel {
            self.dataSource = data
        } else {
            assert(false, "数据传输失败")
        }
    }
   
    
    // MARK: - ListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        
        guard let item = self.dataSource else {
            fatalError()
        }
        
        self.photoManager.requestImage(picture: item, targetSize: CGSize.zero) { [weak self] image, info in
            
            guard let image = image ,let self = self else {
                fatalError()
            }
            
            if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? LocalImageCell {
                cell.image = image
            }
            self.requestImage = image
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
        
    }

}
