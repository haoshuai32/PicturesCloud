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
import Photos

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
        
        guard self.selectedData.count > 0 else {
            return
        }
        
//        let resources = PHAssetResource.assetResources(for: asset)
//        var itemData = Data()
//        PHAssetResourceManager.default().requestData(for: resources.first!, options: nil) { data in
//            itemData.append(data)
//
//        } completionHandler: { error in
//            debugPrint("original size", itemData.count)
//            Client.shared.api.requestNormal(.uploadUserFiles(itemData, "urpl5sn1qmoiucq9", "jeb1793"), callbackQueue: nil, progress: nil) { result in
//                switch result {
//                case .success(let resonse):
////                    debugPrint(resonse.request?.headers)
////                    debugPrint(String.init(data: resonse.data, encoding: .utf8))
//                    debugPrint("上传照片成功",resonse.statusCode,String.init(data: resonse.data, encoding: .utf8))
//
//                    if (resonse.statusCode == 200) {
//                        Client.shared.api.requestNormal(.uploadUserFilesP("urpl5sn1qmoiucq9", "jeb1793"), callbackQueue: nil, progress: nil) { result in
//                            switch result {
//                            case .success(let resonse):
//                                debugPrint("处理照片成功",resonse.statusCode,String.init(data: resonse.data, encoding: .utf8))
////                                debugPrint(resonse.request?.headers)
////                                debugPrint(String.init(data: resonse.data, encoding: .utf8))
////                                debugPrint("成功",resonse.statusCode,resonse.request?.headers)
//                            case .failure(let error):
//                                debugPrint(error)
//                            }
//                        }
//                    }
//
//                case .failure(let error):
//                    debugPrint(error)
//                }
//            }
//
//
//
//        }
        
        
//        HUploadManager.shared.append(self.selectedData.map{$0})
        HUploadManager.shared.start(data: self.selectedData.map{$0})
        
//        HUploadManager.shared.uploadData(data: data) {reponse,data,error in
//            debugPrint("文件上传成功")
//            Client.shared.api.requestNormal(.uploadUserFilesP(Client.shared.userID!, "jeb1792"), callbackQueue: nil, progress: nil) { result in
//                switch result {
//                case .success(let reponse):
//
//                    debugPrint("reponse", String.init(data: reponse.data, encoding: String.Encoding.utf8))
//
//                case let .failure(error):
//                    debugPrint("错误 error",error)
//                }
//            }
//        }
        
//    http://127.0.0.1:2342/api/v1/users/urpl5sn1qmoiucq9/upload/jeb7x2
        
//        Client.shared.api.requestNormal(.getPhotos(PhotoOptions.init()), callbackQueue: nil, progress: nil) { result in
//            switch result {
//            case .success(let response):
//                print(response.request)
//                print(response.response)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
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
