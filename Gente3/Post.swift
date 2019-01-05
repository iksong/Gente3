//
//  Post.swift
//  Gente
//
//  Created by IKSong on 7/25/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

struct Post: Codable {
    let title: String
    let body: String
}

extension Post: CellConfigurable {
    
    var cellID: String {
        return "PostCell"
    }
    
    var cellClass: UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    func configure(_ cell: UITableViewCell) {
        cell.textLabel?.text = title
    }
    
    static func urlForUserID(id: String) -> URL? {
        let urlStr = "\(BackEnd.post.urlString())\(id)"
        return URL(string: urlStr)
    }
    
    static func postResourceForUserID(id: String) -> Resource<[Post]>? {
        guard let url = Post.urlForUserID(id: id) else { return nil }
        return Resource<[Post]>.init(withURLRequest: URLRequest(url: url))
    }
}
