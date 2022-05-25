//
//  LocalViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit
import IGListKit
import IGListDiffKit

protocol LocalChangeSelectedDelegate:AnyObject {
    func localChangeSelected(dataSource: Set<LocalPictureModel>)
}

// TODO: 切换segment的时候没有记录滑动位置

class LocalViewController: UIViewController,
ListAdapterDataSource,
PhotoManagerChangeDelegate,
                           LocalChangeSelectedDelegate

{
  
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    /// 0 全部 1 视频 2 照片
    private var selectIndex: Int = 0
    
    private let photoManager = LocalPhotoManager()
    
    private var dataSource: [LocalPictureSectionModel] = []
    
    private var selectedDataSource: Set<LocalPictureModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - LocalChangeSelectedDelegate
    func localChangeSelected(dataSource: Set<LocalPictureModel>) {
        self.selectedDataSource = dataSource
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
        self.dataSource = self.photoManager.requestDataSource(self.selectIndex)
        return self.dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = LocalPictureSectionController(selected: self.selectedDataSource,manager: self.photoManager,delegate: self)
        
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
