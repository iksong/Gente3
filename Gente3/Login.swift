//
//  Login.swift
//  Gente3
//
//  Created by Serge Gainsbourg on 9/4/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import SwiftUI
import Combine

class UserModel {
    var email: String = ""
    var password: String = ""
    var isLoggedIn: Bool = false
    init() {
        self.email = ""
        self.password = ""
        self.isLoggedIn = false
    }
}
//class LoginModel: ObservableObject {
//    @Published var userModel = UserModel()
//}

struct Login: View {
    @Binding var shouldDismiss: Bool
    @Binding var model: UserModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    emailView
                    passwordView
                }
                Section {
                    Button("Log In") {
                        shouldDismiss = true
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Log In")
            .navigationBarItems(trailing:
                Button("Cancel") {
                    shouldDismiss = true
                }
            )
            .onAppear { shouldDismiss = false }
        }
    }
    
    var emailView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Email")
                .font(.headline)
            TextField("Email", text: $model.email).font(.largeTitle)
        }
    }
    
    var passwordView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Password")
                .font(.headline)
            TextField("Password", text: $model.password).font(.largeTitle)
        }
    }
    
}

