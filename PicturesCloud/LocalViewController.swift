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

    @IBAction func uploadButtonAction(_ sender: Any?) {
        
        guard self.selectedDataSource.count > 0 else { return }
        
        let data = Array<LocalPictureModel>.init(self.selectedDataSource)
        let asset = data.first!.asset
        switch asset.mediaType {
            
        case .unknown:
            debugPrint("unknown")
        case .image:
            debugPrint("image")
        case .video:
            debugPrint("video")
        case .audio:
            debugPrint("audio")
        @unknown default:
            fatalError()
        }
        debugPrint(asset.mediaSubtypes.rawValue)
        switch asset.mediaSubtypes {
        case .photoPanorama:
            debugPrint("photoPanorama")
            break
        case .photoHDR:
            debugPrint("photoHDR")
            break
        case .photoScreenshot:
            debugPrint("photoScreenshot")
            break
        case .photoLive:
            debugPrint("photoLive")
            break
        case .videoStreamed:
            debugPrint("videoStreamed")
            break
        case .videoHighFrameRate:
            debugPrint("videoStreamed")
            break
        case .videoTimelapse:
            debugPrint("videoHighFrameRate")
            break
        case .photoDepthEffect:
            debugPrint("photoDepthEffect")
            break
        default:
            debugPrint("资源现有类型解析不出来",asset.mediaSubtypes.rawValue)
//            fatalError()
        }
//        debugPrint(data.first?.asset)
//        print(data.first?.asset)
//        debugPrint(data.first?.asset.mediaType,data.first?.asset.mediaSubtypes)
        
//        HUploadManager.shared.append(data)
//        HUploadManager.shared.start()
    }
    
    @IBAction func onSegmentControl(_ sender: UISegmentedControl) {
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
