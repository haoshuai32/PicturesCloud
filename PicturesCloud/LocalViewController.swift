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
class LocalViewController: UIViewController, ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    let photoManager = LocalPhotoManager()
    
    var dataSource: [PictureSectionModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = photoManager.requestDataSource()
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
    }

    // MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PictureSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
