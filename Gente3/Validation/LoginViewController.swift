//
//  LoginViewController.swift
//  HF
//
//  Created by IKSong on 11/9/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    /**
     An UIButton that has action to login.
     */
    private let loginButton = UIButton()
    
    /**
     An UIButton that has action to cancel.
     */
    private let cancelButton = UIButton()
    
    /**
     An UITextField that has email iput.
     */
    private let emailTextField = UITextField()
    
    /**
     An UITextField that has password iput.
     */
    private let passwordTextField = UITextField()
    
    /**
     An UILabel that has email error text.
     */
    private let emailErrorLabel = UILabel()
    
    /**
     An UILabel that has password error text.
     */
    private let passwordErrorLabel = UILabel()
    
    /**
     A scrollView that holds all subviews in the view.
     */
    private let scrollView = UIScrollView()
    
    /**
     An array of ValidationRule type.
     */
    lazy var validationRules = [ValidationRule(field: emailTextField, rule: EmailRule(), errorLabel: emailErrorLabel), ValidationRule(field: passwordTextField, rule: PasswordRule(), errorLabel: passwordErrorLabel)]
    
    //MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        validateAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    //MARK: - Target Action
    
    /**
     Dismiss self.
     
     - parameter sender: an UIButton.
     */
    @objc func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Calls login service - we do not have a service to call.
     Sets `UserManager.sharedInstance.isLoggedIn`.
     
     - parameter sender: an UIButton.
     */
    @objc func loginTapped(_ sender: UIButton) {
        // login service call here
        // since we do not have a service to call, dismissing self
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Dismisses Keyboard.
     
     - parameter sender: an UIButton.
     */
    @objc func dismissKeyboard() {
        view.endEditing(true)
        validateAll()
    }
    
    /**
     Read notification's user info and adjust scrollView's content inset for keyboard frame.
     
     - parameter sender: UIKeyboardWillShow notification.
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            var inset = scrollView.contentInset
            inset.bottom = keyboardHeight
            scrollView.contentInset = inset
        }
    }
    
    /**
     Read notification's user info and adjust scrollView's content inset for keyboard frame.
     
     - parameter sender: UIKeyboardWillHide notification.
     */
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK:- Private methods
    
    /**
     Looping through `validationRules` array, if all passes, enables `loginButton`.
     If any of rule in `validationRules` array fails, disables `loginButton`.
     Sets `loginButton` alpha based on pass or not.
     */
    private func validateAll() {
        loginButton.isEnabled = validationRules.map({$0.rule.validate($0.field.text ?? "")}).reduce(true) {$0 && $1}
        loginButton.alpha = loginButton.isEnabled ? 1.0 : 0.4
    }
    
    /**
     Registers self to UIKeyboardWillShow, UIKeyboardWillHide notifications.
     */
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /**
     Unegisters self from UIKeyboardWillShow, UIKeyboardWillHide notifications.
     */
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    /**
     Creates an UIStackView with email label, textField, error label.
     Creates an UIStackView with password label, textField, error label.
     Configures `loginButton`, `cancelButton`.
     Apply sytles.
     */
    private func setupUI() {
        //email stackview setup
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.apply(style: .smallTitle)
        emailTextField.apply(style: .grayEmail)
        emailTextField.delegate = self
        emailErrorLabel.text = EmailRule().errorMessage
        emailErrorLabel.apply(style: .redError)
        let emailStackView = MultiLabelsView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), firstLabel: emailLabel, secondLabel: emailErrorLabel).contentView
        emailStackView.addArrangedSubview(emailTextField)
        emailErrorLabel.isHidden = true
        emailStackView.spacing = 3
        
        //password stackview setup
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.apply(style: .smallTitle)
        passwordErrorLabel.apply(style: .redError)
        passwordErrorLabel.text = PasswordRule().errorMessage
        passwordTextField.apply(style: .grayPassword)
        passwordTextField.delegate = self
        let passwordStackView = MultiLabelsView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), firstLabel: passwordLabel, secondLabel: passwordErrorLabel).contentView
        passwordStackView.addArrangedSubview(passwordTextField)
        passwordErrorLabel.isHidden = true
        passwordStackView.spacing = 3
        
        //login button setup
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.apply(style: .black)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginTapped), for: .touchUpInside)
        
        //put all UI in the form to one stackview
        let stackview = UIStackView()
        stackview.addArrangedSubview(emailStackView)
        stackview.addArrangedSubview(passwordStackView)
        stackview.addArrangedSubview(loginButton)
        
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        stackview.alignment = .leading
        stackview.spacing = 10
        stackview.translatesAutoresizingMaskIntoConstraints = false

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackview)
        view.addSubview(scrollView)
        
        // close button setup
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.apply(style: .white)
        cancelButton.addTarget(self, action: #selector(LoginViewController.cancelTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false 
        constraintToTopRight(cancelButton, constantToTop: 25, constantToRight: 20, widthConstant: 60, heightConstant: 40)
        
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: stackview.widthAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: stackview.widthAnchor),
            loginButton.widthAnchor.constraint(equalTo: stackview.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            ])

        // setup tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // keyboard notification
        addKeyboardObservers()
    }
}

extension LoginViewController: UITextFieldDelegate {
    /**
     Resign first responder and validate text field. Calls `validateAll` method.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validationRules.filter({$0.field === textField}).first?.validateTextField()
        validateAll()
        return true
    }
    
    /**
     Validate text field.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        validationRules.filter({$0.field === textField}).first?.validateTextField()
    }
}
