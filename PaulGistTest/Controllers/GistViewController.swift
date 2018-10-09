//
//  GistViewController.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit
import AVFoundation

class GistViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentView: UIView!
    
    var gistdata: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        
        // add a touch recognizer to remove keyboard on screen touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        gistdata = GistManager.sharedInstance.getCurrentGistDisplayData()
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hides keyboard when touch happens outside textview
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        
        textView.resignFirstResponder()
    }
    
}



// MARK: - Table view data source

extension GistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = gistdata {
            
            return data.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let data = gistdata {
            
            let index = data[indexPath.row]
            
            if let type: String = index["type"] as? String {
                
                if type == "header" {
                    
                    return 84
                }
            }
        }
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = gistdata {
            
            let index = data[indexPath.row]
            
            if let type: String = index["type"] as? String {

                if type == "header" {
                    
                    let cell = tableView.dequeueReusableCell( withIdentifier: "GistHeaderViewCellReuse",
                                                              for: indexPath) as! GistHeaderViewCell
                    
                    let head: GistHeader = (index["data"] as? GistHeader)!
                    cell.setupWith(data: head)
                    return cell
                }
            }
        }
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "GistHeaderViewCellReuse",
                                                  for: indexPath) as! GistHeaderViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
