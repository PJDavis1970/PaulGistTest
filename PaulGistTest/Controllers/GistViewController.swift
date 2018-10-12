//
//  GistViewController.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit
import AVFoundation

/*
protocol GistCellViewDelegate {
    
    func updated(height: CGFloat, viewId: Int)
}
*/
class GistViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentView: UIView!
    
//    var expandingCellHeight: CGFloat = 64
    
    var gistDisplayData: [GistDisplayEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
        tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        // add a touch recognizer to remove keyboard on screen touch
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        DispatchQueue.main.async {
            GistManager.sharedInstance.getGist(id: GistManager.sharedInstance.getSelectedGistId()) {
                [weak self] (result: Bool) in
            
                if result == true {

                    self?.gistDisplayData = GistManager.sharedInstance.getCurrentGistDisplay()
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else {
                    
                    self?.navigationController?.popViewController(animated: true)
                }
                UIViewController.removeSpinner(spinner: sv)
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

extension GistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = gistDisplayData else {
            
            return 0
        }
        
        return data.count
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
//                cell.delegate = self
                cell.setupWith(data: entry.data as! GistFile, viewId: indexPath.row)
                return cell
                
            case .comment:
                
                let cell = tableView.dequeueReusableCell( withIdentifier: "GistCommentViewCellReuse",
                                                          for: indexPath) as! GistCommentViewCell
//                cell.delegate = self
                cell.setupWith(data: entry.data as! GistComment, viewId: indexPath.row)
                return cell
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

extension GistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
/*
extension GistViewController: GistCellViewDelegate {
    
    func updated(height: CGFloat, viewId: Int) {
        
        expandingCellHeight = height
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        tableView.beginUpdates()
        tableView.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
    }
}

fileprivate extension GistViewController {
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let keyBoardValueBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let keyBoardValueEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyBoardValueBegin != keyBoardValueEnd else {
                return
        }
        
        let keyboardHeight = keyBoardValueEnd.height
        
        tableView.contentInset.bottom = keyboardHeight
    }
}
*/
