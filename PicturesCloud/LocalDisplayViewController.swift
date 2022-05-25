//
//  LocalDisplayViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/25.
//

import UIKit
import IGListKit
class LocalDisplayViewController: UIViewController,
                                  ListAdapterDataSource
{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = { [unowned self] in
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 4)
    }()
    
    private var displayIndex: Int = 0
    
    private let photoManager: LocalPhotoManager
    
    private var dataSource: [LocalPictureModel] = []
    
    private var selectedDataSource: Set<LocalPictureModel> = []
    
    private weak var delegate: LocalChangeSelectedDelegate?
    
    required init(index: Int,
                  manager: LocalPhotoManager,
                  dataSource: [LocalPictureModel],
                  selected: Set<LocalPictureModel>,
                  delegate: LocalChangeSelectedDelegate) {
        self.displayIndex = index
        self.dataSource = dataSource
        self.selectedDataSource = selected
        self.photoManager = manager
        self.delegate = delegate
        
        super.init(nibName: "LocalDisplayViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return LocalImageSectionController(manager: self.photoManager)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
