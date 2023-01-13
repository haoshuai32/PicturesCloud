//
//  GridViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/6/1.
//

import UIKit
import IGListKit
import IGListDiffKit

class GridListItem {
    let identifier: String
    let dataSouce: [GridItem]
    required init(identifier: String,
                  dataSouce: [GridItem]
    ) {
        self.identifier = identifier
        self.dataSouce = dataSouce
    }
    
}

extension GridListItem:ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? GridItem else { return false }
        return object.identifier == identifier
    }
}


// noti: 必须子类化
class GridViewController: UIViewController,
                          ListAdapterDataSource,
                          AssetChangeSelectedDelegate
{
    
    /// 0 全部 1 视频 2 照片
    var selectTypeIndex: Int = 0
    
    var dataSource: [GridListItem] = []
    
    var selectedData: Set<GridItem> = []
    
    func collectionView() -> UICollectionView {
        fatalError()
        return UICollectionView()
    }
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()
    
    func reloadDataSource() -> [GridListItem] {
        fatalError()
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.dataSource = self.reloadDataSource()
        self.collectionView().setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        self.adapter.collectionView = self.collectionView()
        self.adapter.dataSource = self
        
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        fatalError()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func photoChangeSelected(dataSource: Set<DisplayAsset>) {
        self.selectedData = dataSource
    }
    

}
