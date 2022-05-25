//
//  PictureCell.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit

class LocalPictureCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selelctButton: UIButton!
        
    @IBOutlet weak var durationLabel: UILabel!
    
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
