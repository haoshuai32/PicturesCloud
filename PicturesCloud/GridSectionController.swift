//
//  GridSectionController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/6/1.
//

import UIKit
import IGListKit

typealias GridItem = DisplayAsset

class GridSectionController: ListSectionController,
                             ListWorkingRangeDelegate,
                             ListDisplayDelegate
{
    
    var dataSource:[GridItem] = []
    
    var selectedData:Set<GridItem> = []
    
    weak var delegate: AssetChangeSelectedDelegate?
    
    lazy var itemSize: CGSize = {
        let width = UIScreen.main.bounds.width
        let temp = width - 6.0
        let itemWidth = temp / 3.0
        return CGSize(width: itemWidth, height: itemWidth)
    }()
    
    lazy var targetSize: CGSize = {
        return CGSize(width: itemSize.width * UIScreen.main.scale, height: itemSize.height * UIScreen.main.scale)
    }()
    
    required init(selected: Set<DisplayAsset>,delegate: AssetChangeSelectedDelegate) {
        self.selectedData = selected
        self.delegate = delegate
        
        super.init()
        workingRangeDelegate = self
        displayDelegate = self
        minimumLineSpacing = 3
        minimumInteritemSpacing = 3
    }
    
    @objc func selectButtonAction(_ sender: Any?) {
        
        guard let button = sender as? UIButton else { return }
        
        let index = button.tag
        let item = self.dataSource[index]
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.selectedData.insert(item)
        } else {
            self.selectedData.remove(item)
        }
        self.delegate?.photoChangeSelected(dataSource: self.selectedData)
    }
    
    override func numberOfItems() -> Int {
        return self.dataSource.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return itemSize
    }
    
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
        
        item.readCoverImage(targetSize: targetSize) { [weak self] result in
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
    
    override func didUpdate(to object: Any) {
        if let data = object as? GridListItem {
            self.dataSource = data.dataSouce
        } else {
            fatalError()
        }
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    // MARK: - ListWorkingRangeDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
//        self.photoManager.startCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
//        self.photoManager.stopCachingImages(assets: self.dataSource, targetSize: targetSize)
    }
    
    // MARK: - ListDisplayDelegate
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        guard let pictureCell = cell as? GridCell else {
            fatalError()
            return
        }
        pictureCell.selelctButton.tag = index
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        
    }
    

}
