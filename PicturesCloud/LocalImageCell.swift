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
    
    var image: UIImage? = nil {
        didSet {
            guard let image = self.image else {
                return
            }
                    
            let minScale = imageScale(size: image.size)
            self.scrollView.minimumZoomScale = 1
            scrollView.setZoomScale(minScale, animated: true)
            self.imageView.image = image
        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView:  UIScrollView!
    
    
    
    func imageScale(size: CGSize)-> CGFloat {
        if size.width > self.frame.width {
            let scale = self.frame.width / size.width
            return scale
        }
        return 1.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        scrollView.isMultipleTouchEnabled = true
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        
        

                
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.setZoomScale(1, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapGestureAction(_ gestrue: UIGestureRecognizer) {
        
    }
    

    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
            (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
            (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        
        self.imageView?.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
}
