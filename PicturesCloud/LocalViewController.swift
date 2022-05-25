//
//  LocalViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit
import IGListKit
import IGListDiffKit

// TODO: 切换segment的时候没有记录滑动位置

class LocalViewController: UIViewController, ListAdapterDataSource,PhotoManagerChangeDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    /// 0 全部 1 视频 2 照片
    private var selectIndex: Int = 0
    
    private var dataSource: [LocalPictureSectionModel] = []
    
    let photoManager = LocalPhotoManager()
    
    var selectedDataSource: Set<LocalPictureModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = photoManager.requestDataSource()
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        self.photoManager.changeDelegate = self
        
    }

    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
//        self.adapter.performUpdates(animated: true, completion: nil)
        self.selectIndex = sender.selectedSegmentIndex
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - PhotoManagerChangeDelegate
    
    func photoDidChange() {
        DispatchQueue.main.async {
//            self.adapter.performUpdates(animated: true, completion: nil)
            self.dataSource = self.photoManager.requestDataSource(self.selectIndex)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.photoManager.requestDataSource(self.selectIndex)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return LocalPictureSectionController(selected: self.selectedDataSource,manager: self.photoManager)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
