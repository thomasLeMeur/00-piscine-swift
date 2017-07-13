//
//  ViewController2ViewController.swift
//  d03_photos
//
//  Created by Thomas LE MEUR on 6/15/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController2ViewController: UIViewController, UIScrollViewDelegate {
    var image : UIImage?
    var imageView : UIImageView?
    
    @IBOutlet weak var scroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.addSubview(imageView!)
        scroll.contentSize = (imageView?.frame.size)!
        scroll.minimumZoomScale = CGFloat(min(self.view.bounds.size.width / (self.imageView?.image?.size.width)!, self.view.bounds.size.height / (self.imageView?.image?.size.height)!))
        scroll.maximumZoomScale = 100
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
