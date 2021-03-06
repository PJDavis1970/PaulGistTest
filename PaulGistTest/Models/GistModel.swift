//
//  GistModel.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import Foundation
import UIKit

// GistDisplayType.  These are the types of cells when displaying the Gist screen.  Each section is a seperate cell
enum GistDisplayType {
    
    case header
    case file
    case comment
}

// GistDisplayEntry.  This defines the data for each cell on the gist display screen
class GistDisplayEntry {
    
    var type: GistDisplayType
    var data: Any
    
    init(type: GistDisplayType, data: Any) {
        
        self.type = type
        self.data = data
    }
}

class GistDisplayHeader {
    
    var name: String
    var descrip: String
    var imageUrl: String
    var created: String
    
    init(gist: GistObject) {
        
        self.name = gist.owner.login
        
        var descripText = ""
        if let des = gist.description {
            
            descripText = des
        }
        self.descrip = descripText
        self.imageUrl = gist.owner.avatar_url
        self.created = gist.created_at
    }
}

class GistDisplayFile {
    
}

class GistDisplayComment {
    
}

class GistBookmark : NSObject, Codable {
    
    let login: String
    let descrip: String
    let id: String
    let imageUrl: String
    
    init(gist: GistObject) {
        
        self.login = gist.owner.login
        self.imageUrl = gist.owner.avatar_url
        
        var descripText = ""
        if let des = gist.description {
            
            descripText = des
        }
        self.descrip = descripText
        self.id = gist.id        
    }
}



//========================================================================
// GIST API data structures.
// TODO : Make all values from API optional.  We do not know which values will be present and
// to prevent any form of crashes we have to assume any value could be missing.
//
// GistObject this is the codable object for the main Gist data sctructure
class GistObject : Codable {
    
    let url: String
    let forks_url: String
    let commits_url: String
    let id: String
    let node_id: String
    let git_pull_url: String
    let git_push_url: String
    let html_url: String
    let files: GistFiles
    let _public: Bool
    let created_at: String
    let updated_at: String
    var description: String? = nil
    let comments: Int
    let user: GistUser?
    let comments_url: String
    let owner: GistOwner
    let truncated: Bool
    let forks: [GistForks]
    let history: [GistHistory]
    var comment_list: [GistComment]? = nil
    
    enum CodingKeys: String, CodingKey {

        case url = "url"
        case forks_url = "forks_url"
        case commits_url = "commits_url"
        case id = "id"
        case node_id = "node_id"
        case git_pull_url = "git_pull_url"
        case git_push_url = "git_push_url"
        case html_url = "html_url"
        case files = "files"
        case _public = "public"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case description = "description"
        case comments = "comments"
        case user = "user"
        case comments_url = "comments_url"
        case owner = "owner"
        case truncated = "truncated"
        case forks = "forks"
        case history = "history"
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try values.decode(String.self, forKey: .url)
        self.forks_url = try values.decode(String.self, forKey: .forks_url)
        self.commits_url = try values.decode(String.self, forKey: .commits_url)
        self.id = try values.decode(String.self, forKey: .id)
        self.node_id = try values.decode(String.self, forKey: .node_id)
        self.git_pull_url = try values.decode(String.self, forKey: .git_pull_url)
        self.git_push_url = try values.decode(String.self, forKey: .git_push_url)
        self.html_url = try values.decode(String.self, forKey: .html_url)
        self.files = try values.decode(GistFiles.self, forKey: .files)
        self._public = try values.decode(Bool.self, forKey: ._public)
        self.created_at = try values.decode(String.self, forKey: .created_at)
        self.updated_at = try values.decode(String.self, forKey: .updated_at)
        self.description = try values.decodeIfPresent(String.self, forKey: .description)
        self.comments = try values.decode(Int.self, forKey: .comments)
        self.user = nil
        self.comments_url = try values.decode(String.self, forKey: .comments_url)
        self.owner = try values.decode(GistOwner.self, forKey: .owner)
        self.truncated = try values.decode(Bool.self, forKey: .truncated)
        self.forks = try values.decode([GistForks].self, forKey: .forks)
        self.history = try values.decode([GistHistory].self, forKey: .history)
    }
}

// GistOwner this is the codable structure for the Gist User Object
class GistOwner : Codable {
    
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try values.decode(String.self, forKey: .login)
        self.id = try values.decode(Int.self, forKey: .id)
        self.node_id = try values.decode(String.self, forKey: .node_id)
        self.avatar_url = try values.decode(String.self, forKey: .avatar_url)
        self.gravatar_id = try values.decode(String.self, forKey: .gravatar_id)
        self.url = try values.decode(String.self, forKey: .url)
        self.html_url = try values.decode(String.self, forKey: .html_url)
        self.followers_url = try values.decode(String.self, forKey: .followers_url)
        self.following_url = try values.decode(String.self, forKey: .following_url)
        self.gists_url = try values.decode(String.self, forKey: .gists_url)
        self.starred_url = try values.decode(String.self, forKey: .starred_url)
        self.subscriptions_url = try values.decode(String.self, forKey: .subscriptions_url)
        self.organizations_url = try values.decode(String.self, forKey: .organizations_url)
        self.repos_url = try values.decode(String.self, forKey: .repos_url)
        self.events_url = try values.decode(String.self, forKey: .events_url)
        self.received_events_url = try values.decode(String.self, forKey: .received_events_url)
        self.type = try values.decode(String.self, forKey: .type)
        self.site_admin = try values.decode(Bool.self, forKey: .site_admin)
    }
}

// GistFiles this is the codable object for Gist Files
class GistFiles : Codable {

    var file_list: [GistFile]
    
    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        self.file_list = [GistFile]()
        for key in values.allKeys {
            let value = try values.decode(GistFile.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.file_list.append(value)
        }
    }
}

class GistFile : Codable {
    
    let filename: String
    let type: String
    let language: String
    let raw_url: String
    let size: Int
    let truncated: Bool
    let content: String
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.filename = try values.decode(String.self, forKey: .filename)
        self.type = try values.decode(String.self, forKey: .type)
        self.language = try values.decode(String.self, forKey: .language)
        self.raw_url = try values.decode(String.self, forKey: .raw_url)
        self.size = try values.decode(Int.self, forKey: .size)
        self.truncated = try values.decode(Bool.self, forKey: .truncated)
        self.content = try values.decode(String.self, forKey: .content)
    }
}

// GistForks with the the codable structure for Gist Forks
class GistForks : Codable {

    let user: GistUser
    let url: String
    let id: String
    let created_at: String
    let updated_at: String
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.user = try values.decode(GistUser.self, forKey: .user)
        self.url = try values.decode(String.self, forKey: .url)
        self.id = try values.decode(String.self, forKey: .id)
        self.created_at = try values.decode(String.self, forKey: .created_at)
        self.updated_at = try values.decode(String.self, forKey: .updated_at)
    }
}

class GistUser: Codable {
    
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try values.decode(String.self, forKey: .login)
        self.id = try values.decode(Int.self, forKey: .id)
        self.node_id = try values.decode(String.self, forKey: .node_id)
        self.avatar_url = try values.decode(String.self, forKey: .avatar_url)
        self.gravatar_id = try values.decode(String.self, forKey: .gravatar_id)
        self.url = try values.decode(String.self, forKey: .url)
        self.html_url = try values.decode(String.self, forKey: .html_url)
        self.followers_url = try values.decode(String.self, forKey: .followers_url)
        self.following_url = try values.decode(String.self, forKey: .following_url)
        self.gists_url = try values.decode(String.self, forKey: .gists_url)
        self.starred_url = try values.decode(String.self, forKey: .starred_url)
        self.subscriptions_url = try values.decode(String.self, forKey: .subscriptions_url)
        self.organizations_url = try values.decode(String.self, forKey: .organizations_url)
        self.repos_url = try values.decode(String.self, forKey: .repos_url)
        self.events_url = try values.decode(String.self, forKey: .events_url)
        self.received_events_url = try values.decode(String.self, forKey: .received_events_url)
        self.type = try values.decode(String.self, forKey: .type)
        self.site_admin = try values.decode(Bool.self, forKey: .site_admin)
    }
}

//GistHistory this is the codable structure for Gist History
class GistHistory : Codable {
    
    let url: String
    let version: String
    let change_status: GistChangeStatus
    let committed_at: String
 
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try values.decode(String.self, forKey: .url)
        self.version = try values.decode(String.self, forKey: .version)
        self.change_status = try values.decode(GistChangeStatus.self, forKey: .change_status)
        self.committed_at = try values.decode(String.self, forKey: .committed_at)
    }
}

class GistChangeStatus : Codable {
    
    let deletions: Int
    let additions: Int
    let total: Int
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.deletions = try values.decode(Int.self, forKey: .deletions)
        self.additions = try values.decode(Int.self, forKey: .additions)
        self.total = try values.decode(Int.self, forKey: .total)
    }
}

class GistComment : Codable {

    let id: Int
    let node_id: String
    let url: String
    let body: String
    let user: GistUser
    let created_at: String
    let updated_at: String
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.node_id = try values.decode(String.self, forKey: .node_id)
        self.url = try values.decode(String.self, forKey: .url)
        self.body = try values.decode(String.self, forKey: .body)
        self.user = try values.decode(GistUser.self, forKey: .user)
        self.created_at = try values.decode(String.self, forKey: .created_at)
        self.updated_at = try values.decode(String.self, forKey: .updated_at)
    }
}
