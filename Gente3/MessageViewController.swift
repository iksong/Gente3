//
//  MessageViewController.swift
//  iOS Architectures
//
//  Created by Dave DeLong on 10/27/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import UIKit

protocol MessageViewControllerDelegate: class {
    func messageViewControllerActionButtonWasTapped(_ messageVC: MessageViewController)
}

/// A simple view controller that shows a message and lets you tap a button
class MessageViewController: UIViewController {

    weak var delegate: MessageViewControllerDelegate?
    private let message: String
    private let buttonLabel: String
    
    @IBOutlet var messageLabel: UILabel?
    @IBOutlet var actionButton: UIButton?
    
    init(message: String, buttonLabel: String = "Try Again") {
        self.message = message
        self.buttonLabel = buttonLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("die") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel?.text = message
        actionButton?.setTitle(buttonLabel, for: .normal)
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        delegate?.messageViewControllerActionButtonWasTapped(self)
    }

}
