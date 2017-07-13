//
//  ViewController.swift
//  d03_photos
//
//  Created by Thomas LE MEUR on 6/15/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collec: UICollectionView!
    var imgsInSearching : Int = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Datas.imgs.count
    }
    
    func createAlert(mess: String) {
        let alert = UIAlertController(title: "My Title", message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collecCell", for: indexPath) as! myCell
        
        if cell.imageView.image == nil && cell.failed == false {
            let qos = DispatchQoS.userInitiated.qosClass
            let queue = DispatchQueue.global(qos: qos)
            cell.circle.hidesWhenStopped = true
            cell.circle.startAnimating()
            self.imgsInSearching += 1;
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            queue.async {
                let url = URL(string: Datas.imgs[indexPath.row])
                var toPut = false
                if let u = url {
                    let data = try? Data(contentsOf: u)
                    if data != nil {
                        toPut = true
                    }
                }
                DispatchQueue.main.async {
                    if toPut == true {
                        let data = try? Data(contentsOf: url!)
                        cell.imageView.image = UIImage(data: data!)
                    } else {
                        self.createAlert(mess: "Cannot access to \(Datas.imgs[indexPath.row])")
                        cell.failed = true
                    }
                    cell.circle.stopAnimating()
                    self.imgsInSearching -= 1;
                    if self.imgsInSearching == 0 {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.subviews[indexPath.row] as? myCell
        if cell?.imageView.image != nil {
            if let img = cell?.imageView.image {
                performSegue(withIdentifier: "goSeg", sender: img)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSeg" {
            if let vc = segue.destination as? ViewController2ViewController {
                vc.imageView = UIImageView(image: sender as! UIImage)
            }
        }
    }
}

