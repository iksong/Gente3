//
//  UIViewController+SimpleTransition.swift
//  iOS Architectures
//
//  Created by Dave DeLong on 10/27/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3
        
        let current = children.last
        addChild(child)
        
        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds
        
        if let existing = current {
            existing.willMove(toParent: nil)
            
            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParent()
                child.didMove(toParent: self)
                completion?(done)
            })
            
        } else {
            view.addSubview(newView)
            
            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParent: self)
                completion?(done)
            })
        }
    }
    
    func popTopView(completion: ((Bool) -> Void)? = nil) {
        if let topView = children.last {
            topView.willMove(toParent: nil)
            topView.view.removeFromSuperview()
            topView.removeFromParent()
            topView.didMove(toParent: self)
            completion?(true)
        }
    }
    
    func constraintToTop(_ viewToAdd: UIView, constant: CGFloat, spacing: CGFloat) {
        view.addSubview(viewToAdd)
        
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            viewToAdd.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacing),
            viewToAdd.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -spacing)
            ])
    }
    
    func constraintToTopRight(_ viewToAdd: UIView, constantToTop: CGFloat, constantToRight: CGFloat, widthConstant: CGFloat, heightConstant: CGFloat) {
        view.addSubview(viewToAdd)
        
        NSLayoutConstraint.activate([
            viewToAdd.topAnchor.constraint(equalTo: view.topAnchor, constant: constantToTop),
            viewToAdd.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -constantToRight),
            viewToAdd.widthAnchor.constraint(equalToConstant: widthConstant),
            viewToAdd.heightAnchor.constraint(equalToConstant: heightConstant)
            ])
    }
    
}
