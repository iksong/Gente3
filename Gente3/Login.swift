//
//  Login.swift
//  Gente3
//
//  Created by Serge Gainsbourg on 9/4/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import SwiftUI
import Combine

struct UserModel {
    var email: String = ""
    var password: String = ""
    var isLoggedIn: Bool = false
}
class LoginModel: ObservableObject {
    @Published var userModel = UserModel()
}

struct Login: View {
    @State var email: String = ""
    @State var password: String = ""
    @ObservedObject var model: LoginModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    emailView
                    passwordView
                }
                Section {
                    Button("Log In") {
                        model.userModel.isLoggedIn = true 
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Log In")
        }
    }
    
    var emailView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Email")
                .font(.headline)
            TextField("Email", text: $model.userModel.email).font(.largeTitle)
        }
    }
    
    var passwordView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Password")
                .font(.headline)
            TextField("Password", text: $model.userModel.password).font(.largeTitle)
        }
    }
    
}

