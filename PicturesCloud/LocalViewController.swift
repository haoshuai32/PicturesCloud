//
//  LocalViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit
import IGListKit
import IGListDiffKit
import RxSwift

protocol AssetChangeSelectedDelegate:AnyObject {
    func photoChangeSelected(dataSource: Set<DisplayAsset>)
}

// TODO: 切换segment的时候没有记录滑动位置

class LocalViewController: GridViewController {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView;
    }
    
    private let photoManager:LocalPhotoManager = LocalPhotoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return LocalSectionController(selected: self.selectedData, delegate: self)
    }
    
    override func reloadDataSource() -> [GridListItem] {
        let list = photoManager.requestDataSource(selectTypeIndex)
        guard let fr = list.first else {
            return []
        }
        let item = GridListItem(identifier: fr.identifier, dataSouce: list)
        return [item]
    }
    
    @IBAction func loginButtonAction(_ sender: Any?) {
        Client.login(username: "haoshuai",password: "19920105")
    }
    
    @IBAction func uploadButtonAction(_ sender: Any?) {
        debugPrint("开始上传",self.selectedData.count)
        
        guard let data = self.selectedData.first else {
            return
        }
        
        API.shared.requestNormal(.getPhotos(PhotoOptions.init()), callbackQueue: nil, progress: nil) { result in
            switch result {
            case .success(let response):
                print(response.request?.headers ?? "")
                print(response.request?.httpMethod ?? "")
                print(response.response ?? "")
                
                print(String.init(data: response.data, encoding: .utf8))
            case .failure(let error):
                print(error)
            }
//            print(result.get().request ?? "")
//            print(result.get().response ?? "")
//            print(String.init(data: result.get().data, encoding: .utf8))
//            print(result.get().data)
        }
//        API.shared.rx.request(.getPhotos(PhotoOptions.init()))
//            .subscribe { repose in
//                print(repose)
//            } onFailure: { error in
//                print(error)
//            } onDisposed: {
//                print("dis")
//            }
//            .disposed(by: DisposeBag())

//            .subscribe { repose in
//                print(repose)
//            }.disposed(by: DisposeBag())
//        HUploadManager.shared.uploadData(data: data) {
//
//        }
        
        
    }
    
    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.selectTypeIndex = index
        self.dataSource = self.reloadDataSource()
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - Observer
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.PhotoLibraryChange.Inserted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.PhotoLibraryChange.Removed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.PhotoLibraryChange.Moves, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(_:)), name: NSNotification.Name.PhotoLibraryChange.Changed, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func notificationAction(_ sender: Notification) {
        // 如果是移除 需要进行数据的移除
        DispatchQueue.main.async {
            self.dataSource = self.reloadDataSource()
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
}
