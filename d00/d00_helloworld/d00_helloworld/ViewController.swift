//
//  ViewController.swift
//  d00_helloworld
//
//  Created by Thomas LE MEUR on 6/12/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textButton: UILabel!
    
    @IBAction func clickButton(_ sender: UIButton) {
        if textButton.text == "Hello World !" {
            textButton.text = "Kikou"
        } else {
            textButton.text = "Hello World !"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

