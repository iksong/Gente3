//
//  TwoLabelsView.swift
//  SwapViews
//
//  Created by IKSong on 10/19/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 Configurable, re-usable view that has multiple lables.
 */
final class MultiLabelsView: UIView {
    /**
     Title of the first label in the view.
     */
    var firstTitle: String = ""
    
    /**
     Title of the second label in the view.
     */
    var secondTitle: String = ""
    
    /**
     The first label in the view.
     */
    lazy var firstLabel: UILabel = {
        let view = UILabel()
        view.text = self.firstTitle
        return view
    }()
    
    /**
     The second label in the view.
     */
    lazy var secondLabel: UILabel = {
        let view = UILabel()
        view.text = self.secondTitle
        return view
    }()
    
    /**
     A stackView that hold two labels
     */
    lazy var contentView = UIStackView()
    
    /**
     `contentView` spacing.
     */
    var contentViewSpacing: CGFloat = 5 {
        didSet {
            self.contentView.spacing = contentViewSpacing
        }
    }
    
    /**
     `contentView` axis.
     */
    var contentViewAxis: UILayoutConstraintAxis = UILayoutConstraintAxis.vertical {
        didSet {
            self.contentView.axis = contentViewAxis
        }
    }
    
    /**
     `contentView` alignment.
     */
    var contentViewAlignment: UIStackViewAlignment = UIStackViewAlignment.fill {
        didSet {
            self.contentView.alignment = self.contentViewAlignment
        }
    }
    
    /**
     Initializer.
     
     - parameter frame: a frame for the view.
     - parameter firstTitle: title for the first label.
     - parameter secondTitle: title for the second label.
     */
    init(frame: CGRect, firstTitle: String, secondTitle: String) {
        super.init(frame: frame)
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.initializeViews()
    }
    
    /**
     Initializer.
     
     - parameter frame: a frame for the view.
     - parameter firstLabel: the first label.
     - parameter secondLabel: the second label.
     */
    init(frame: CGRect, firstLabel: UILabel, secondLabel: UILabel) {
        super.init(frame: frame)
        self.firstLabel = firstLabel
        self.secondLabel = secondLabel
        self.initializeViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Configures `contentView` with subviews. Constraints the subviews.
     */
    private func initializeViews() {
        //stackview setup
        contentView.axis = contentViewAxis
        contentView.distribution = .fillProportionally
        contentView.alignment = contentViewAlignment
        contentView.spacing = contentViewSpacing
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addArrangedSubview(firstLabel)
        contentView.addArrangedSubview(secondLabel)
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
    }
}
