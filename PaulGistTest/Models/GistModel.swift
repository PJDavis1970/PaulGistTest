//
//  GistModel.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import UIKit

class GistHeader : NSObject, Codable {
    
    init(gist: [String:Any]) {
        
        // check if we have owner details and login name of owner
        if let owner: [String: Any] = gist["owner"] as? [String : Any] {
            
            if let login: String = owner["login"] as? String {
                
                self.login = login
            }
        
            // check if we have an avitar
            if let avitar: String = owner["avatar_url"] as? String {
                
                self.imageUrl = avitar
            }
        
        }
        
        // check if we have a project description
        if let descrip: String = gist["description"] as? String {
            
            self.descrip = descrip
        }
        
        // check if we have a gist id
        if let id: String = gist["id"] as? String {
            
            self.id = id
        }
        
    }
    
    var login: String = ""
    var descrip: String = ""
    var id: String = ""
    var imageUrl: String = ""
}




// TODO add the correct structure to use for codable and JSON decoding.
// Swift 4 makes this easy.  However for this test I dont think I will have time to add it all

class GistObject : NSObject, Codable {
    
    let url: String = ""
    let forks_url: String = ""
    let commits_url: String = ""
    let id: String = ""
    let node_id: String = ""
    let git_pull_url: String = ""
    let git_push_url: String = ""
    let html_url: String = ""
    let files: [GistFiles] = []
    
}

class GistFiles : NSObject, Codable {

}

class GistOwner : NSObject, Codable {
    
}

class GistForks : NSObject, Codable {
    
}

class GistHistory : NSObject, Codable {
    
}

/*
{

    "files": {
        "hello_world.rb": {
            "filename": "hello_world.rb",
            "type": "application/x-ruby",
            "language": "Ruby",
            "raw_url": "https://gist.githubusercontent.com/octocat/6cad326836d38bd3a7ae/raw/db9c55113504e46fa076e7df3a04ce592e2e86d8/hello_world.rb",
            "size": 167,
            "truncated": false,
            "content": "class HelloWorld\n   def initialize(name)\n      @name = name.capitalize\n   end\n   def sayHi\n      puts \"Hello !\"\n   end\nend\n\nhello = HelloWorld.new(\"World\")\nhello.sayHi"
        },
        "hello_world.py": {
            "filename": "hello_world.py",
            "type": "application/x-python",
            "language": "Python",
            "raw_url": "https://gist.githubusercontent.com/octocat/e29f3839074953e1cc2934867fa5f2d2/raw/99c1bf3a345505c2e6195198d5f8c36267de570b/hello_world.py",
            "size": 199,
            "truncated": false,
            "content": "class HelloWorld:\n\n    def __init__(self, name):\n        self.name = name.capitalize()\n       \n    def sayHi(self):\n        print \"Hello \" + self.name + \"!\"\n\nhello = HelloWorld(\"world\")\nhello.sayHi()"
        },
        "hello_world_ruby.txt": {
            "filename": "hello_world_ruby.txt",
            "type": "text/plain",
            "language": "Text",
            "raw_url": "https://gist.githubusercontent.com/octocat/e29f3839074953e1cc2934867fa5f2d2/raw/9e4544db60e01a261aac098592b11333704e9082/hello_world_ruby.txt",
            "size": 46,
            "truncated": false,
            "content": "Run `ruby hello_world.rb` to print Hello World"
        },
        "hello_world_python.txt": {
            "filename": "hello_world_python.txt",
            "type": "text/plain",
            "language": "Text",
            "raw_url": "https://gist.githubusercontent.com/octocat/e29f3839074953e1cc2934867fa5f2d2/raw/076b4b78c10c9b7e1e0b73ffb99631bfc948de3b/hello_world_python.txt",
            "size": 48,
            "truncated": false,
            "content": "Run `python hello_world.py` to print Hello World"
        }
    },
 
 
    "public": true,
    "created_at": "2010-04-14T02:15:15Z",
    "updated_at": "2011-06-20T11:34:15Z",
    "description": "Hello World Examples",
    "comments": 0,
    "user": null,
    "comments_url": "https://api.github.com/gists/aa5a315d61ae9438b18d/comments/",
 
 
    "owner": {
        "login": "octocat",
        "id": 1,
        "node_id": "MDQ6VXNlcjE=",
        "avatar_url": "https://github.com/images/error/octocat_happy.gif",
        "gravatar_id": "",
        "url": "https://api.github.com/users/octocat",
        "html_url": "https://github.com/octocat",
        "followers_url": "https://api.github.com/users/octocat/followers",
        "following_url": "https://api.github.com/users/octocat/following{/other_user}",
        "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
        "organizations_url": "https://api.github.com/users/octocat/orgs",
        "repos_url": "https://api.github.com/users/octocat/repos",
        "events_url": "https://api.github.com/users/octocat/events{/privacy}",
        "received_events_url": "https://api.github.com/users/octocat/received_events",
        "type": "User",
        "site_admin": false
    },
 
    "truncated": false,
 
    "forks": [
    {
    "user": {
    "login": "octocat",
    "id": 1,
    "node_id": "MDQ6VXNlcjE=",
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "gravatar_id": "",
    "url": "https://api.github.com/users/octocat",
    "html_url": "https://github.com/octocat",
    "followers_url": "https://api.github.com/users/octocat/followers",
    "following_url": "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
    "organizations_url": "https://api.github.com/users/octocat/orgs",
    "repos_url": "https://api.github.com/users/octocat/repos",
    "events_url": "https://api.github.com/users/octocat/events{/privacy}",
    "received_events_url": "https://api.github.com/users/octocat/received_events",
    "type": "User",
    "site_admin": false
    },
    "url": "https://api.github.com/gists/dee9c42e4998ce2ea439",
    "id": "dee9c42e4998ce2ea439",
    "created_at": "2011-04-14T16:00:49Z",
    "updated_at": "2011-04-14T16:00:49Z"
    }
    ],
 
    "history": [
    {
    "url": "https://api.github.com/gists/aa5a315d61ae9438b18d/57a7f021a713b1c5a6a199b54cc514735d2d462f",
    "version": "57a7f021a713b1c5a6a199b54cc514735d2d462f",
    "user": {
    "login": "octocat",
    "id": 1,
    "node_id": "MDQ6VXNlcjE=",
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "gravatar_id": "",
    "url": "https://api.github.com/users/octocat",
    "html_url": "https://github.com/octocat",
    "followers_url": "https://api.github.com/users/octocat/followers",
    "following_url": "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
    "organizations_url": "https://api.github.com/users/octocat/orgs",
    "repos_url": "https://api.github.com/users/octocat/repos",
    "events_url": "https://api.github.com/users/octocat/events{/privacy}",
    "received_events_url": "https://api.github.com/users/octocat/received_events",
    "type": "User",
    "site_admin": false
    },
    "change_status": {
    "deletions": 0,
    "additions": 180,
    "total": 180
    },
    "committed_at": "2010-04-14T02:15:15Z"
    }
    ]
}
*/
