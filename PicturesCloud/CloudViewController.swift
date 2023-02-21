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
import ObjectMapper
import Photos
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

        Client.shared.api.requestNormal(.getPhotos(PhotoOptions()), callbackQueue: nil, progress: nil) { result in
            switch result {
            case let .success(reponse):
                guard reponse.statusCode == 200, let jsonStr = String.init(data: reponse.data, encoding: .utf8) else {
                    return
                }
                debugPrint(jsonStr)
                guard let photos = Mapper<Photo>().mapArray(JSONString: jsonStr) else {
                    return
                }
                let uid = photos.first!.UID!
                
                let list = photos.map { item in
                    
                    var assetType:AssetType = .image
                    switch item.PhotoType {

                    case .live:
                        assetType = .live
                    case .image:
                        assetType = .image
                        break
                    case .video:
                        assetType = .video(Double(item.Duration))
                    case .gif:
                        assetType = .gif
                    }
                    
                    return PhotoAsset(identifier: item.UID!, assetType: assetType, data: .cloud(item), creationDate: Date())
                    
                }
                let data = GridListItem(identifier: uid, dataSouce: list)
                self.dataSource = [data]
//                self.dataSource = self.reloadDataSource()
                DispatchQueue.main.async {
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
                
            case let .failure(_):
                break
                
            }
        }

        return []
    }
    
    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.selectTypeIndex = index
        self.dataSource = self.reloadDataSource()
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any?) {
        guard let data = self.selectedData.first?.dataSource.data() as? Photo else {
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status != .authorized {
                debugPrint("相机没有权限")
                return
            }
        }
        
        let available = PHAssetCreationRequest.supportsAssetResourceTypes([PHAssetResourceType.photo.rawValue as NSNumber,
                                    PHAssetResourceType.pairedVideo.rawValue as NSNumber])
        debugPrint("是否可以 livephoto", available)
        DownloadManager.shared.downloadData(data: data) { reponse, data, error in
            
        }
        
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

