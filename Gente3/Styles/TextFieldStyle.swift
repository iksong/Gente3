//
//  TextFieldStyle.swift
//  HF
//
//  Created by IKSong on 11/9/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 Describes styles of UITextField.
 */
struct TextFieldStyle {
    let font: UIFont
    let borderColor: UIColor
    let borderWidth: CGFloat = 1.0

    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .done
    var isSecureEntry: Bool = false
    
    /**
     Initializer.
     
     - parameter borderColor: UITextField border color.
     - parameter font: UITextField font.
     */
    init(borderColor: UIColor, font: UIFont) {
        self.borderColor = borderColor
        self.font = font
    }
    
    /**
     Returns a TextFieldStyle - gray background color, font size of 32, keyboard type of email address.
     */
    static var grayEmail: TextFieldStyle {
        var style = TextFieldStyle(borderColor: UIColor(white: 0.3, alpha: 1.0), font: UIFont.systemFont(ofSize: 32))
        style.keyboardType = .emailAddress
        return style
    }
    
    /**
     Returns a TextFieldStyle - gray background color, font size of 32, secured entry.
     */
    static var grayPassword: TextFieldStyle {
        var style = TextFieldStyle(borderColor: UIColor(white: 0.3, alpha: 1.0), font: UIFont.systemFont(ofSize: 32))
        style.isSecureEntry = true
        return style
    }
}

extension UITextField: Styleable {
    /**
     Sets text field style.
     
     - parameter style: a style to be appled to the text field.
     */
    func apply(style: TextFieldStyle) {
        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = style.borderWidth
        font = style.font
        keyboardType = style.keyboardType
        returnKeyType = style.returnKeyType
        isSecureTextEntry = style.isSecureEntry
    }
}
