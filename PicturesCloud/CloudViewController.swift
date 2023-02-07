//
//  CloudViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit
import IGListKit
import IGListDiffKit
import RxSwift
// 云册照片
class CloudViewController: GridViewController {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CloudSectionController(selected: self.selectedData, delegate: self)
    }
    
    override func reloadDataSource() -> [GridListItem] {
//        let list = photoManager.requestDataSource(selectTypeIndex)
//        guard let fr = list.first else {
//            return []
//        }
//        let item = GridListItem(identifier: fr.identifier, dataSouce: list)
//        return [item]
        return []
    }
    
    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.selectTypeIndex = index
        self.dataSource = self.reloadDataSource()
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    

//    func loadDataSource() {
////        Client.shared.api.rx.request(.getPhotos(PhotoOptions()))
//        Client.shared.api.requestNormal(.getPhotos(PhotoOptions()), callbackQueue: nil, progress: nil) { result in
//            switch result {
//
//            }
//        }
//    }

}

