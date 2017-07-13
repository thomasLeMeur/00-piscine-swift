//
//  ViewController.swift
//  deathNote
//
//  Created by Thomas LE MEUR on 6/14/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var mainTable: UITableView! {
        didSet {
            mainTable.delegate = self
            mainTable.dataSource = self
        }
    }
    @IBOutlet weak var myTable: UITableView! {
        didSet {
            myTable.delegate = self
            myTable.dataSource = self
        }
    }
    
    func calculateHeight(inString : String) -> CGFloat {
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)]
        let attributedString : NSAttributedString = NSAttributedString(string: inString, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfRow = self.calculateHeight(inString: Data.notes[indexPath.row].2)
        return (heightOfRow + 40.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! mainCellTableViewCell
        cell.note = Data.notes[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "backSegue" {
                self.myTable.reloadData()
        }
    }
}

