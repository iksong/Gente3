//
//  FlowViewController.swift
//  Gente3
//
//  Created by KS23225 on 11/22/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

class FlowViewController: UIViewController {
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add right button item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Alert", style: .plain, target: self, action: #selector(showAlert))
        
        setupMenu()
    }
    
    private func setupMenu() {
        let userTableButton = UIButton()
        userTableButton.apply(style: .black)
        userTableButton.setTitle("User - TableView", for: .normal)
        userTableButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        userTableButton.addTarget(self, action: #selector(showUsersTable), for: .touchUpInside)
        userTableButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userTableButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let userCollectionButton = UIButton()
        userCollectionButton.apply(style: .black)
        userCollectionButton.setTitle("User - CollectionView", for: .normal)
        userCollectionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        userCollectionButton.addTarget(self, action: #selector(showUsersCollection), for: .touchUpInside)
        userCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userCollectionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let stackV = UIStackView()
        stackV.axis = .vertical
        stackV.spacing = 15
        stackV.addArrangedSubview(userTableButton)
        stackV.addArrangedSubview(userCollectionButton)
        
        stackV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackV)
        constraintToTop(stackV, constant: 200, spacing: 50)
    }
    
    @objc func showUsersTable() {
        let userVC = UsersTableViewController(items: [], resource: User.resourceForAllUsers(), cellDescriptor: CellDescriptor(configure: {$1.configure($0)}))
        userVC.delegate = self

        navigationController?.pushViewController(userVC, animated: true)
    }
    
    @objc func showUsersCollection() {
        
    }

    func loadResource<T: Codable>(_ resource: Resource<[T]>) where T: CellConfigurable {
        let postVC = ItemsTableViewController<T>(items: [], resource: resource, cellDescriptor: CellDescriptor(configure: {$1.configure($0)}))
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    @objc func showAlert() {
        let alertController = UIAlertController.init(title: "Smart Alert", cancelButtonTitle: "No Way", okButtonTitle: "Yes, please") { result in
            switch result {
            case .cancel:
                print("Cancel")
            case .ok(let inputString):
                print("You entered : \(inputString)")
            }
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

extension FlowViewController: UsersTableViewControllerDelegate {
    func userTableViewControllerDidSelectUser(_ user: User) {
        guard let resource = Post.postResourceForUserID(id: String(user.id)) else { return }
        loadResource(resource)
    }
}
