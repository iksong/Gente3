//
//  UserModel.swift
//  Gente3
//
//  Created by Serge Gainsbourg on 9/5/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import Foundation
import Combine

class UserModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    @Published var emailErrorMessage = ""
    @Published var passwordErrorMessage = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return EmailRule().validate(input)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { input in
                return PasswordRule().validate(input)
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map {
                return $0 ? "" : PasswordRule().errorMessage
            }
            .assign(to: \.passwordErrorMessage, on: self)
            .store(in: &cancellableSet)
        
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .map {
                return $0 ? "" : EmailRule().errorMessage
            }
            .assign(to: \.emailErrorMessage, on: self)
            .store(in: &cancellableSet)
    }
}
