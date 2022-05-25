//
//  PictureCell.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/23.
//

import UIKit

class PictureCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selelctButton: UIButton!
    
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
