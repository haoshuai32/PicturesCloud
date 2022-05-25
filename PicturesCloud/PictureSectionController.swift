//
//  PictureSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/24.
//

import UIKit
import IGListKit

class PictureSectionController:
    ListSectionController, ListWorkingRangeDelegate, ListDisplayDelegate
{
    
    var dataSource: [PictureModel] = []
    
    private
    lazy var cacheImage: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    
    private
    lazy var itemSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let temp = width - 15.0
        let itemWidth = temp / 3.0
        return CGSize(width: itemWidth, height: itemWidth)
    }()
    
    private
    lazy var targetSize: CGSize = {
        return CGSize(width: itemSize.width * UIScreen.main.scale, height: itemSize.height * UIScreen.main.scale)
    }()
    
    override init() {
        super.init()
        workingRangeDelegate = self
        displayDelegate = self
        minimumLineSpacing = 2.5
        minimumInteritemSpacing = 2.5
    }
    
    override func numberOfItems() -> Int {
        return self.dataSource.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return itemSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext!.dequeueReusableCell(withNibName: "PictureCell", bundle: nil, for: self, at: index) as? PictureCell else {
            fatalError()
        }
        if let image = self.cacheImage.object(forKey: "\(index)" as NSString) {
            cell.imageView.image = image
        } else {
            
            guard let localViewController = self.viewController as? LocalViewController else {
                fatalError()
            }
            let _ = localViewController.photoManager.requestThumbnail(index: index, targetSize: targetSize) { [weak self] image, info in
                if let image = image {
                    self?.cacheImage.setObject(image, forKey: "\(index)" as NSString)
                }
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        if let data = object as? PictureSectionModel {
            self.dataSource = data.dataSource
        } else {
            assert(false, "数据传输失败")
        }
    }
   
    // MARK: - ListDisplayDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {

    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        guard let localViewController = listAdapter.viewController as? LocalViewController else {
            return
        }
        debugPrint("willDisplay cell index",index)
        
        let _ = localViewController.photoManager.requestThumbnail(index: index, targetSize: targetSize) { [weak self] image, info in
            if let image = image {
                self?.cacheImage.setObject(image, forKey: "\(index)" as NSString)
            }
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        
    }
    
    
    // MARK: - ListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        guard let localViewController = listAdapter.viewController as? LocalViewController else {
            return
        }
        let count = localViewController.dataSource[0].dataSource.count
        
        var indexs: [Int] = []
        for i in 0..<count {
            indexs.append(i)
        }
        
        localViewController.photoManager.startCachingImages(indexs: indexs, targetSize: targetSize)
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {}

}
