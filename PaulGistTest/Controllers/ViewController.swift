//
//  ViewController.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit
import Auth0

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    
    var bookmarks:[GistBookmark]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        credentialsManager.credentials { [weak self] error, credentials in
            guard error == nil, let credentials = credentials else {
                
                DispatchQueue.main.async {
                    
                    self?.setButtonStatus(status: false)
                }
                return
            }
            DispatchQueue.main.async {
                
                self?.setButtonStatus(status: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        bookmarks = GistManager.sharedInstance.getBookmarks()
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
    
    func setButtonStatus(status: Bool) {
        
        AppData.sharedInstance.setLoggedIn( loggedIn: status )
        if status {
        
            self.loginButton.setTitle("Log Out", for: .normal)
        } else {
            
            self.loginButton.setTitle("Log in", for: .normal)
        }
        
    }
    
    
    @IBAction func LoginPressed(_ sender: Any) {

        // TODO remove this and place in own class
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        
        if AppData.sharedInstance.isLoggedIn() {
        
            credentialsManager.clear()
            self.setButtonStatus(status: false)
        } else {
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://pjdavis1970.eu.auth0.com/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        // Handle the error
                        print("Error: \(error)")
                    case .success(let credentials):
                        // Do something with credentials e.g.: save them.
                        // Auth0 will automatically dismiss the login page
                        credentialsManager.store(credentials: credentials)
                        DispatchQueue.main.async {
                            
                            self.setButtonStatus(status: true)
                        }
                    }
            }
        }
    }
}


// MARK: - Table view data source

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = bookmarks else {
            
            return 0
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 128
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "HistoryListViewReuseCell",
                                                  for: indexPath) as! HistoryListViewCell
        
        if let data = bookmarks {
            
            cell.setupWith(data: data[indexPath.row])
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = bookmarks {
            
            GistManager.sharedInstance.setSelectedGistId(id: data[indexPath.row].id)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GistViewController") as! GistViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}
