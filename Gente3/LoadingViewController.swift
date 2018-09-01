//
//  LoadingViewController.swift
//  iOS Architectures
//
//  Created by Dave DeLong on 10/27/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // In theory, we don't need this implementation at all,
    // but being able to call .init() is convenient
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
