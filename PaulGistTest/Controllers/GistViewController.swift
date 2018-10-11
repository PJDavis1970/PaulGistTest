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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentView: UIView!
    
    var gistDisplayData: [GistDisplayEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        tableView.estimatedRowHeight = 84
        tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        // add a touch recognizer to remove keyboard on screen touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        DispatchQueue.main.async {
        GistManager.sharedInstance.getGist(id: GistManager.sharedInstance.getSelectedGistId()) {
            [weak self] (result: Bool) in
            
            if result == true {

                self?.gistDisplayData = GistManager.sharedInstance.getCurrentGistDisplay()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        }
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
        
        guard let data = gistDisplayData else {
            
            return 0
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let data = gistDisplayData {
            
            let entry = data[indexPath.row]
            
            switch entry.type {
                
            case .header:
                return 84
                
            case .file:
                return 124
                
            case .comment:
                return 84
            }
        }
        
        return 20
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let data = gistDisplayData {
            
            let entry = data[indexPath.row]
            
            switch entry.type {
                
            case .header:
                    
                let cell = tableView.dequeueReusableCell( withIdentifier: "GistHeaderViewCellReuse",
                                                            for: indexPath) as! GistHeaderViewCell
                cell.setupWith(data: entry.data as! GistDisplayHeader)
                return cell

            case .file:
                    
                let cell = tableView.dequeueReusableCell( withIdentifier: "GistFileViewCellReuse",
                                                            for: indexPath) as! GistFileViewCell
                    
//                let file: [String: Any] = (index["data"] as? [String: Any])!
//                cell.setupWith(data: file)
                return cell
                
            case .comment:
                break
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
