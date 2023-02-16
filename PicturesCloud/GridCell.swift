//
//  GridCell.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/6/1.
//

import UIKit

class GridCell: UICollectionViewCell {

    @IBOutlet weak var liveTypeView: UIImageView!
    
    @IBOutlet weak var gifTypeView: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selelctButton: UIButton!
        
    @IBOutlet weak var durationLabel: UILabel!
    // var cloudDataSource:
//    var dataSource: DisplayAsset.AssetCoverImage? = nil {
//        didSet {
//            guard let dataSource = dataSource else {
//                return
//            }
//            switch dataSource {
//            case .image(let image):
//                liveTypeView.isHidden = true
//                gifTypeView.isHidden = true
//                durationLabel.isHidden = true
//                imageView.image = image
//                break
//            case .photoLive(let live):
//                liveTypeView.isHidden = false
//                gifTypeView.isHidden = true
//                durationLabel.isHidden = true
//                imageView.image = live
//                break
//            case .video(let value):
//                liveTypeView.isHidden = true
//                gifTypeView.isHidden = true
//                durationLabel.isHidden = false
//                imageView.image = value.0
//                duration = value.1
//                break
//            case .gif(let gif):
//                liveTypeView.isHidden = true
//                gifTypeView.isHidden = false
//                durationLabel.isHidden = true
//                imageView.image = gif
//                break
//            }
//        }
//    }
    
    var duration: Double = 0 {
        didSet {
            let min = self.duration / 60.0
            let sec = self.duration.truncatingRemainder(dividingBy: 60.0)
            self.durationLabel.text = "\(Int(min)):\(Int(sec))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if #available(iOS 13.0, *) {
            selelctButton.setImage(UIImage(systemName: "circle")!, for: .normal)
            selelctButton.setImage(UIImage(systemName: "circle.fill")!, for: .selected)
        } else {
            // Fallback on earlier versions
        }
    }

}
