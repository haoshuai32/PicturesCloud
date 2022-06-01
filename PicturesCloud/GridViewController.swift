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


// 必须子类话
class GridViewController: UIViewController,
                          ListAdapterDataSource
{
    
    private let photoManager:LocalPhotoManager = LocalPhotoManager.shared

    private var dataSource: [GridListItem] = []
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

}
