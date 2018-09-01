//
//  UIAlertControllerExtension.swift
//  Gente3
//
//  Created by Song, InKyung on 8/19/18.
//  Copyright © 2018 IKSong. All rights reserved.
//

import UIKit

//let emailRegex = try! NSRegularExpression(pattern: ".+@.+\\..+")
//let emailRule = TextValidationRule.regularExpression(emailRegex)
//emailRule.isValid("alice@example.com") // → true
//emailRule.isValid("bob@gmail") // → false


//let integerRule = TextValidationRule.predicate({ Int($0) != nil })
//integerRule.isValid("-789") // → true
//integerRule.isValid("123a") // → false

enum TextValidationRule {
    case noRestriction
    case nonEmpty
    case regularExpression(NSRegularExpression)
    case predicate((String) -> Bool)
    
    func isValid(_ inputString: String) -> Bool {
        switch self {
        case .noRestriction:
            return true
        case .nonEmpty:
            return !inputString.isEmpty
        case .regularExpression(let regex):
            let fullRagne = NSRange.init(inputString.startIndex..., in: inputString)
            return regex.rangeOfFirstMatch(in: inputString, options: .anchored, range: fullRagne) == fullRagne
        case .predicate(let pred):
            return pred(inputString)
        }
    }
}

extension UIAlertController {
    enum TextInputResult {
        case cancel
        case ok(String)
    }
    
    convenience init(title: String,
                     message: String? = nil,
                     cancelButtonTitle: String,
                     okButtonTitle: String,
                     validate validationRule: TextValidationRule = .noRestriction,
                     textFiedlConfiguration: ((UITextField) -> Void)? = nil,
                     onCompetion: @escaping (TextInputResult) -> Void) {
        
        self.init(title: title, message: message, preferredStyle: .alert)
        
        class TextFieldObserver: NSObject, UITextFieldDelegate {
            let textFiedlValueChanged: (UITextField) -> Void
            let textFieldShouldReturn: (UITextField) -> Bool
            
            init(textField: UITextField, valueChanged: @escaping (UITextField) -> Void, shouldReturn: @escaping (UITextField) -> Bool) {
                self.textFiedlValueChanged = valueChanged
                self.textFieldShouldReturn = shouldReturn
                
                super.init()
                
                textField.delegate = self
                textField.addTarget(self, action: #selector(TextFieldObserver.textFieldValueChanged(sender:)), for: .editingChanged)
            }
            
            @objc func textFieldValueChanged(sender: UITextField) {
                textFiedlValueChanged(sender)
            }
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                return textFieldShouldReturn(textField)
            }
        }
        
        var textFieldObserver: TextFieldObserver?
        
        func finish(result: TextInputResult) {
            textFieldObserver = nil
            onCompetion(result)
        }
        
        let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { _ in
            finish(result: .cancel)
        }
        
        let okAction = UIAlertAction.init(title: okButtonTitle, style: .default) { [unowned self] _ in
            finish(result: .ok(self.textFields?.first?.text ?? ""))
        }
        
        addAction(cancelAction)
        addAction(okAction)
        preferredAction = okAction
        
        addTextField { textField in
            textFiedlConfiguration?(textField)
            textFieldObserver = TextFieldObserver.init(textField: textField, valueChanged: { textField in
                okAction.isEnabled = validationRule.isValid(textField.text ?? "")
            }, shouldReturn: { textField -> Bool in
                validationRule.isValid(textField.text ?? "")
            })
        }
    }
}
