//
//  Rules.swift
//  HF
//
//  Created by IKSong on 11/8/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

/**
 The `Rule` protocol declares the required method and property for all objects that subscribe to it.
 */
protocol Rule {
    /**
     Error message of a value that has failed validation.
     */
    var errorMessage: String { get }
    
    /**
     Validates text.
     
     - parameter value: String of text to be validated.
     - returns: Boolean value. True if validation is successful; False if validation fails.
     */
    func validate(_ value: String) -> Bool
}

/**
 Enum that groups Regex rules.
 */
enum RegexRuleType {
    case email
    case password
    
    /**
     Returns a regex string for each case.
     */
    var regexString: String {
        switch self {
        case .email:    return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case .password: return "^(?=.*?[0-9])(?=.*?[a-z]).*?$"
        }
    }
    
    /**
     Returns a error message string for each case.
     */
    var errorMessage: String {
        switch self {
        case .email:    return "Please enter a valid email."
        case .password: return "Password needs to have at least one letter and one number."
        }
    }
}

/**
 Rule for email.
 */
class EmailRule: Rule {
    var errorMessage: String = RegexRuleType.email.errorMessage
    
    func validate(_ value: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", RegexRuleType.email.regexString)
        return test.evaluate(with: value)
    }
}

/**
 Rule for Password.
 */
class PasswordRule: Rule {
    var errorMessage: String = RegexRuleType.password.errorMessage
    
    func validate(_ value: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", RegexRuleType.password.regexString)
        return test.evaluate(with: value)
    }
}

/**
 A struct that holds a UITextField and it's rule to be tested against, and errorLable to be shown when validation falied.
 */
struct ValidationRule {
    let field: UITextField
    let rule: Rule
    let errorLabel: UILabel
    
    /**
     Validates the text in the field(UITextField).
     Updates field's border color based on validation.
     Shows/hides errorLabel based on validation.
     */
    func validateTextField() {
        let passed = rule.validate(field.text ?? "")
        field.layer.borderColor = passed ? UIColor.green.cgColor : UIColor.red.cgColor
        field.layer.borderWidth = 1.0
        errorLabel.isHidden = passed ? true : false
    }
}

