//
//  LocalImageCell.swift
//  PicturesCloud
//
//  Created by haoshuai on 2022/5/25.
//

import UIKit

class LocalImageCell: UICollectionViewCell
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
//    private var imageScrollView: HImageScrollView?
    
    var image: UIImage? = nil {
        
        didSet {
            
            guard let image = self.image else {
                return
            }
            
            imageView.image = image
            
//            if imageScrollView == nil {
//                self.imageScrollView = HImageScrollView(frame: self.bounds)
//
//                self.addSubview(imageScrollView!)
//            }
//            imageScrollView?.image = image
            
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

  
}

extension LocalImageCell: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        debugPrint(#function)
        
        return imageView
        
    }

    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        debugPrint(#function)
        
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
            (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
            (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        
        self.imageView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
    
}
