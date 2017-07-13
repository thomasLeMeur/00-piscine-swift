//
//  ViewController.swift
//  d00_calculator
//
//  Created by Thomas LE MEUR on 6/12/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var number: UILabel!
    var res:CLongLong = 0
    var tmp:CLongLong = 0
    var op:Int = 0
    var first:Int = 1

    func updateN(_ sender: CLongLong)
    {
        if op == 5 {
            res = 0
            tmp = 0
            op = 0
            first = 1
        }
        if tmp < 0 {
            if tmp < -2147483648 {
                tmp = 0
                res = 0
                first = 1
                op = 0
                number.text = "Overflow"
                return
            }
            tmp = tmp * 10 - sender
        } else {
            if tmp > 2147483647 {
                tmp = 0
                res = 0
                first = 1
                op = 0
                number.text = "Overflow"
                return
            }
            tmp = tmp * 10 + sender
        }
        number.text = "\(tmp)"
    }
    
    func doOp(_ sender: Int)
    {
        if first == 1 {
            res = tmp
            first = 0
        }
        else {
            if op == 1 {
                res -= tmp
            }
            else if op == 2 {
                res += tmp
            }
            else if op == 3 {
                res *= tmp
            }
            else if op == 4 && tmp != 0 {
                res /= tmp
            }
        }
        if res < -2147483648 || res > 2147483647 {
            tmp = 0
            res = 0
            first = 1
            op = 0
            number.text = "Overflow"
            return
        }
        tmp = 0
        op = sender
        number.text = "\(res)"
    }
    
    @IBAction func n0(_ sender: UIButton) {
        updateN(0)
        print("Action : 0")
    }
    
    @IBAction func n1(_ sender: UIButton) {
        updateN(1)
        print("Action : 1")
    }
    
    @IBAction func n2(_ sender: UIButton) {
        updateN(2)
        print("Action : 2")
    }
    
    @IBAction func n3(_ sender: UIButton) {
        updateN(3)
        print("Action : 3")
    }
    
    @IBAction func n4(_ sender: UIButton) {
        updateN(4)
        print("Action : 4")
    }
    
    @IBAction func n5(_ sender: UIButton) {
        updateN(5)
        print("Action : 5")
    }
    
    @IBAction func n6(_ sender: UIButton) {
        updateN(6)
        print("Action : 6")
    }
    
    @IBAction func n7(_ sender: UIButton) {
        updateN(7)
        print("Action : 7")
    }
    
    @IBAction func n8(_ sender: UIButton) {
        updateN(8)
        print("Action : 8")
    }
    
    @IBAction func n9(_ sender: UIButton) {
        updateN(9)
        print("Action : 9")
    }
    
    @IBAction func sub(_ sender: UIButton) {
        doOp(1)
        print("Action : -")
    }

    @IBAction func add(_ sender: UIButton) {
        doOp(2)
        print("Action : +")
    }

    @IBAction func mul(_ sender: UIButton) {
        doOp(3)
        print("Action : *")
    }
    
    @IBAction func div(_ sender: UIButton) {
        doOp(4)
        print("Action : /")
    }
    
    @IBAction func eq(_ sender: UIButton) {
        doOp(5)
        print("Action : =")
    }
    
    @IBAction func neg(_ sender: UIButton) {
        tmp = tmp * -1
        number.text = "\(tmp)"
        print("Action : NEG")
    }
    
    @IBAction func ac(_ sender: UIButton) {
        number.text = "0"
        res = 0
        tmp = 0
        print("Action : AC")
    }
    
    @IBAction func less(_ sender: UIButton) {
        
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

