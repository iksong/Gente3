//
//  ViewController.swift
//  Gente3
//
//  Created by KS23225 on 11/22/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit
import SwiftUI

extension UIViewController {
    func addSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content: View {
        let hostingCon = UIHostingController(rootView: swiftUIView)
        addChild(hostingCon)
        view.addSubview(hostingCon.view)
        
        hostingCon.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingCon.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingCon.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostingCon.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            hostingCon.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingCon.didMove(toParent: self)
    }
}

class ViewController: UIViewController {}
