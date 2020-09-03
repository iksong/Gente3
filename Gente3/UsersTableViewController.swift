//
//  UsersTableViewController.swift
//  Gente3
//
//  Created by KS23225 on 11/22/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

protocol UsersTableViewControllerDelegate: class {
    func userTableViewControllerDidSelectUser(_ user: User)
}

class UsersTableViewController: ItemsTableViewController<User> {
    weak var delegate: UsersTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userTableViewControllerDidSelectUser(items[indexPath.row])
    }
}

class UsersCollectionViewController: ItemsCollectionViewController<User> {
    weak var delegate: UsersTableViewControllerDelegate?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.userTableViewControllerDidSelectUser(items[indexPath.row])
    }
}
