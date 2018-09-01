//
//  ButtonStyle.swift
//  HF
//
//  Created by IKSong on 11/8/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 Describes styles of UIButton.
 */
struct ButtonStyle {
    let textColor: UIColor
    let font: UIFont
    var backgroundColor: UIColor = UIColor(white: 0.25, alpha: 1.0)
    
    /**
     Initializer.
     
     - parameter textColor: button title text color.
     - parameter font: lable titleLable font.
     */
    init(textColor: UIColor, font: UIFont) {
        self.textColor = textColor
        self.font = font
    }
    
    /**
     Returns a ButtonStyle - black backgournd color, white text color with font size of 19.
     */
    static var black: ButtonStyle {
        return ButtonStyle(textColor: .white, font: UIFont.systemFont(ofSize: 19))
    }
    
    /**
     Returns a ButtonStyle - white background color, black text color with font size of 14.
     */
    static var white: ButtonStyle {
        var style = ButtonStyle(textColor: .black, font: UIFont.systemFont(ofSize: 14))
        style.backgroundColor = .white
        return style
    }
}

extension UIButton: Styleable {
    
    /**
     Sets button style.
     
     - parameter style: a style to be appled to the button.
     */
    func apply(style: ButtonStyle) {
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.textColor, for: .normal)
        self.titleLabel?.font = style.font
    }
}
