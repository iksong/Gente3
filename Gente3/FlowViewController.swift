//
//  FlowViewController.swift
//  Gente3
//
//  Created by KS23225 on 11/22/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

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
        let userTableButton = UIButton(primaryAction: UIAction { _ in
            self.showUsersTable()
        })
        configureButton(userTableButton, with: "User - TableView")
        
        let userCollectionButton = UIButton(primaryAction: UIAction { _ in
            self.showUsersCollection()
        })
        configureButton(userCollectionButton, with: "User - CollectionView")
        
        let loginButton = UIButton(primaryAction: UIAction { _ in
            self.showLogin()
        })
        configureButton(loginButton, with: "Login - UIKit")
        
        let login2Button = UIButton(primaryAction: UIAction { _ in
            self.showLoginSWiftUI()
        })
        configureButton(login2Button, with: "Login - SwiftUI")
        
        let stackV = UIStackView()
        stackV.axis = .vertical
        stackV.spacing = 15
        stackV.addArrangedSubview(userTableButton)
        stackV.addArrangedSubview(userCollectionButton)
        stackV.addArrangedSubview(loginButton)
        stackV.addArrangedSubview(login2Button)
        
        stackV.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackV)
        constraintToTop(stackV, constant: 200, spacing: 50)
    }
    
    func configureButton(_ button: UIButton, with title: String) {
        button.apply(style: .black)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func showLogin() {
        let loginVC = LoginViewController()
        present(loginVC, animated: true, completion: nil)
    }
    
    var userModelCancellable: AnyCancellable?
    
    var model = UserModel()
    
    var userModel: Binding<UserModel> {
        return Binding<UserModel>(
            get: { return self.model },
            set: { m in
                self.model.email = m.email
                self.model.password = m.password
                self.model.isLoggedIn = m.isLoggedIn
            }
        )
    }
    
    var shouldDismiss: Binding<Bool> {
        return Binding<Bool>(
            get: { return self.model.isLoggedIn },
            set: { value in
                if value {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                }
            }
        )
    }
    
    func showLoginSWiftUI() {
        let hostingCon = UIHostingController(rootView: Login(shouldDismiss: shouldDismiss, model: userModel))
        present(hostingCon, animated: true, completion: nil)
    }
    
    func showUsersTable() {
        let userVC = UsersTableViewController(items: [], resource: User.resourceForAllUsers(), cellDescriptor: CellDescriptor(configure: {$1.configure($0)}))
        userVC.delegate = self

        navigationController?.pushViewController(userVC, animated: true)
    }
    
    func showUsersCollection() {
        let userVC = UsersCollectionViewController(items: [], resource: User.resourceForAllUsers())
        userVC.delegate = self
        navigationController?.pushViewController(userVC, animated: true)
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
