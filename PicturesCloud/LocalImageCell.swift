//
//  LocalImageCell.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/25.
//

import UIKit

class LocalImageCell: UICollectionViewCell,
    UIScrollViewDelegate
{
    private var imageScrollView: HImageScrollView?
    
    var image: UIImage? = nil {
        didSet {
            guard let image = self.image else {
                return
            }
            if imageScrollView == nil {
                self.imageScrollView = HImageScrollView(frame: self.bounds)
                
                self.addSubview(imageScrollView!)
            }
            imageScrollView?.image = image
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

  
}
