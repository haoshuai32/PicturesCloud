//
//  LocalAssetViewController.swift
//  PicturesCloud
//
//  Created by haoshuai on 2023/2/24.
//

import UIKit
import Photos

class LocalAssetViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var asset: PHAsset?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let asset = self.asset else {
            return
        }
        LocalAssetManager.shared.requestGIF(for: asset, options: nil) { imageData, text, property, info in
            guard let data = imageData, let image = UIImage(data: data) else {
                assert(false,"")
                return
            }
            self.imageView.image = image
//            let image = UIImage(data: im)
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
