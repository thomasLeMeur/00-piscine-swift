//
//  ViewController2.swift
//  deathNote
//
//  Created by Thomas LE MEUR on 6/14/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UIDatePicker! {
        didSet {
            date.minimumDate = Date()
        }
    }
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var nname: UITextField!

    @IBAction func doneAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = date.locale!
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.long
        let inputDate = dateFormatter.string(from: date.date)
        
        print("Name : \(nname.text!)")
        print("Date : \(inputDate)")
        print("Death : \(text.text!)")
        print("")
        
        if nname.text! != "" && date.date.description != "" {
            let parts = inputDate.components(separatedBy: " ")
            let realDate = "\(parts[0]) \(parts[1]) \(parts[2]) \(parts[4])"
            Data.notes.append((nname.text!, realDate, text.text!))
        }
        performSegue(withIdentifier: "backSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
