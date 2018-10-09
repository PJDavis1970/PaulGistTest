//
//  ViewController.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var history:[GistHistory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        history = GistManager.sharedInstance.getHistory()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Unwind
    // This is our unwind when force closing qr code scanner
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func test(_ sender: Any) {
        GistApi.sharedInstance.getGist(id: "") { (result) in
            switch result {
            case .success(let posts): break
            //self.posts = posts
            case .failure():
                fatalError("error:")
            }
        }
    }
    

    
}


// MARK: - Table view data source

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = history else {
            
            return 0
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "HistoryListViewReuseCell",
                                                  for: indexPath) as! HistoryListViewCell
        
        if let data = history {
            
            cell.setupWith(data: data[indexPath.row])
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = history {
            
            GistManager.sharedInstance.getGist(id: data[indexPath.row].id) {
                (result: Bool) in
                
                if result == true {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GistViewController") as! GistViewController
                    self.present(nextViewController, animated:true, completion:nil)
                }
            }
        }
    }
}
