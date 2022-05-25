//
//  LocalViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit
import IGListKit
import IGListDiffKit

// 本地照片
class LocalViewController: UIViewController, ListAdapterDataSource,PhotoManagerChangeDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    /// 0 全部 1 视频 2 照片
    private var selectIndex: Int = 0
    
    private var dataSource: [PictureSectionModel] = []
    
    let photoManager = LocalPhotoManager()
    
    var selectedDataSource: Set<PictureModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = photoManager.requestDataSource()
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        self.photoManager.changeDelegate = self
        
    }

    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
        self.selectIndex = sender.selectedSegmentIndex
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - PhotoManagerChangeDelegate
    
    func photoDidChange() {
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true, completion: nil)
            self.dataSource = self.photoManager.requestDataSource(self.selectIndex)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.photoManager.requestDataSource(self.selectIndex)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PictureSectionController(selected: self.selectedDataSource,manager: self.photoManager)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
