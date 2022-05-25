//
//  LocalPictureSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/24.
//

import UIKit
import IGListKit

class LocalPictureSectionController:
    ListSectionController,
        ListWorkingRangeDelegate,
        ListDisplayDelegate
{
    
    private let photoManager:LocalPhotoManager
    
    private var dataSource: [LocalPictureModel] = []
    
    private var selectedDataSource: Set<LocalPictureModel> = []
    
    private
    lazy var cacheImage: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 1000
        cache.totalCostLimit = 1000
        return cache
    }()
    
    private
    lazy var itemSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let temp = width - 6.0
        let itemWidth = temp / 3.0
        return CGSize(width: itemWidth, height: itemWidth)
    }()
    
    private
    lazy var targetSize: CGSize = {
        return CGSize(width: itemSize.width * UIScreen.main.scale, height: itemSize.height * UIScreen.main.scale)
    }()
    
    private func cacheKey(_ index: Int) -> NSString {
        return self.dataSource[index].identifier as NSString
    }
    
    @objc func selectButtonAction(_ sender: Any?) {
        guard let button = sender as? UIButton else { return }
        
        let index = button.tag
        let item = self.dataSource[index]
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.selectedDataSource.insert(item)
        } else {
            self.selectedDataSource.remove(item)
        }
        
        guard let vc = self.viewController as? LocalViewController else {
            fatalError()
            return
        }
        
        vc.selectedDataSource = self.selectedDataSource
        
    }
    
    required init(selected: Set<LocalPictureModel>,manager: LocalPhotoManager) {
        self.selectedDataSource = selected
        self.photoManager = manager
        super.init()
        workingRangeDelegate = self
        displayDelegate = self
        minimumLineSpacing = 3
        minimumInteritemSpacing = 3
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
        
        let item = self.dataSource[index]
        if self.selectedDataSource.contains(item) {
            cell.selelctButton.isSelected = true
        } else {
            cell.selelctButton.isSelected = false
        }

        // add tag
        cell.selelctButton.tag = index
        cell.selelctButton.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)
        
        // set video dura
        if item.mediaType == .video {
            cell.durationLabel.isHidden = false
            cell.duration = item.duration
        } else {
            cell.durationLabel.isHidden = true
        }
        
        // set image
        if let image = self.cacheImage.object(forKey: cacheKey(index)) {
            debugPrint("display in cache", index)
            cell.imageView.image = image
        } else {
            
            let item = self.dataSource[index]
            
            let _ = self.photoManager.requestThumbnail(picture: item, targetSize: targetSize) { [weak self] image, info in
                
                cell.imageView.image = image
                
                if let image = image,let key = self?.cacheKey(index) {
                    self?.cacheImage.setObject(image, forKey: key)
                }
                
                debugPrint("display in request image",index)
            }
            
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        if let data = object as? LocalPictureSectionModel {
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
        guard let pictureCell = cell as? PictureCell else {
            fatalError()
            return
        }
        pictureCell.selelctButton.tag = index
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        
    }
    
    // MARK: - ListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        
        self.photoManager.startCachingImages(pictures: self.dataSource, targetSize: targetSize)
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
        
        self.photoManager.stopCachingImages(pictures: self.dataSource, targetSize: targetSize)
    }

}
