//
//  ItemsTableViewController.swift
//  Gente2
//
//  Created by IKSong on 10/10/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 The `CellConfigurable` protocol declares the required method and properties for all objects that subscribe to it.
 */
protocol CellConfigurable {
    var cellClass: UITableViewCell.Type { get }
    var cellID: String { get }
    func configure(_ cell: UITableViewCell)
}

struct CellDescriptor<T: CellConfigurable> {
    /**
    Closure that takes a CellConfigurable type and an UITableViewCell.
    */
    let configure: (UITableViewCell, T) -> ()
    
    /**
     Initializer.
     
     - parameter configure: a closure that takes a CellConfigurable type and an UITableViewCell.
     */
    init<Cell: UITableViewCell>(configure: @escaping (Cell, T) -> ()) {
        self.configure = { (cell, item) in
            item.configure(cell)
        }
    }
}

/**
 Creates TableViewController with items, type of [T]. Load resourse type of [T] on viewDidLoad.
 */
class ItemsTableViewController<T: CellConfigurable>: UITableViewController where T: Codable {
    
    /**
     Resource that will be loaded from WebService.
     */
    var resource: Resource<[T]>?
    
    /**
     Items that will be displayed on the tableView.
     Item is `CellConfigurable`, registerCell will be called on setting `items`.
     */
    var items: [T] = [] {
        didSet {
            self.regiserCell()
        }
    }
    
    let cellDescriptor: CellDescriptor<T>
    
    //MARK: - Initializer
    
    /**
     Initialize an UITableViewController with items, type of [T], register cell with `CellDescriptor`.
     
     - parameter items: array of type T, T conforms to Codable.
     - paameter resource: an instance of `Resource`.
     - parameter cellDescriptor: an instance of `CellDescritor`.
     */
    init(items: [T], resource: Resource<[T]>?, cellDescriptor: CellDescriptor<T>) {
        self.cellDescriptor = cellDescriptor
        self.items = items
        self.resource = resource
        
        super.init(style: .plain)
        self.regiserCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        loadResource(resource)
    }
    
    /**
     Load resources using WebService and sets `items` and reload tableView
     
     - parameter resource: an object of Resource
     */
    func loadResource(_ resource: Resource<[T]>?) {
        guard let resource = resource, items.isEmpty else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            return
        }

        transition(to: LoadingViewController()) { _ in
            WebService().load(resource: resource) { result in
                switch result {
                case .failure(let errorString):
                    DispatchQueue.main.async {
                        self.popTopView()
                        let messageVC = MessageViewController(message: errorString)
                        messageVC.delegate = self
                        self.transition(to: messageVC)
                    }
                case .success(let items):
                    self.items = items
                    DispatchQueue.main.async {
                        self.popTopView()
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    /**
     Register UITableViewCell for cell reuse identifier.
     Using a member of items array which conforms `CellConfigurable`
     */
    func regiserCell() {
        DispatchQueue.main.async {
            if let firstItem = self.items.first {
                self.tableView.register(firstItem.cellClass, forCellReuseIdentifier: firstItem.cellID)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellID, for: indexPath)
        cellDescriptor.configure(cell, item)
        return cell 
    }
}

extension ItemsTableViewController: MessageViewControllerDelegate {
    func messageViewControllerActionButtonWasTapped(_ messageVC: MessageViewController) {
        loadResource(resource)
    }
}
