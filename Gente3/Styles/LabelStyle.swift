//
//  LabelStyle.swift
//  SwapViews
//
//  Created by IKSong on 10/24/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 The `Styleable` protocol declares the required method for all objects that subscribe to it.
 */
protocol Styleable {
    associatedtype Style
    func apply(style: Style)
}

/**
 Describes styles of UILabel.
 */
struct LabelStyle {
    let textColor: UIColor
    let font: UIFont
    var alignment: NSTextAlignment = .left
    var lineBreakMode: NSLineBreakMode = .byWordWrapping
    var lineNumber: Int = 0
    
    /**
     Initializer.
     
     - parameter textColor: lable's text color.
     - parameter font: lable's font.
     */
    init(textColor: UIColor, font: UIFont) {
        self.textColor = textColor
        self.font = font
    }
    
    /**
     Returns a LabelStyle - black text color with font size of 22 and bold.
     */
    static var blackTitle: LabelStyle {
        return LabelStyle(textColor: UIColor.black, font: UIFont.systemFont(ofSize: 22, weight: .bold))
    }
    
    /**
     Returns a LabelStyle - black text color with font size of 17 and bold.
     */
    static var smallTitle: LabelStyle {
        return LabelStyle(textColor: UIColor.black, font: UIFont.systemFont(ofSize: 17, weight: .bold))
    }
    
    /**
     Returns a LabelStyle - black text color with font size of 17.
     */
    static var smallHeadlineTitle: LabelStyle {
        return LabelStyle(textColor: UIColor.black, font: UIFont.systemFont(ofSize: 17))
    }
    
    /**
     Returns a LabelStyle - black text color with font size of 22.
     */
    static var headlineTitle: LabelStyle {
        return LabelStyle(textColor: UIColor.black, font: UIFont.systemFont(ofSize: 22))
    }
    
    /**
     Returns a LabelStyle - gray text color with font size of 19.
     */
    static var graySubtitle: LabelStyle {
        return LabelStyle(textColor: UIColor(white: 0.4, alpha: 1.0), font: UIFont.systemFont(ofSize: 19))
    }
    
    /**
     Returns a LabelStyle - light gray text color with font size of 14.
     */
    static var lightGraySmall: LabelStyle {
        var style = LabelStyle(textColor: UIColor(white: 0.75, alpha: 1.0), font: UIFont.systemFont(ofSize: 14))
        style.alignment = .right
        return style
    }
    
    /**
     Returns a LabelStyle - red text color with font size of 13.
     */
    static var redError: LabelStyle {
        return LabelStyle(textColor: .red, font: UIFont.systemFont(ofSize: 13))
    }
}

extension UILabel: Styleable {
    
    /**
     Sets label style.
     
     - parameter style: a style to be appled to the label.
     */
    func apply(style: LabelStyle) {
        self.font = style.font
        self.textColor = style.textColor
        self.textAlignment = style.alignment
        self.lineBreakMode = style.lineBreakMode
        self.numberOfLines = style.lineNumber
    }
}
