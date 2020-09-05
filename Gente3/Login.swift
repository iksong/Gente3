//
//  Login.swift
//  Gente3
//
//  Created by Serge Gainsbourg on 9/4/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import SwiftUI
import Combine

struct Login: View {
    @Binding var shouldDismiss: Bool
    @ObservedObject var model: UserModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text(model.emailErrorMessage).foregroundColor(.red)) {
                    emailView
                }
                Section(footer: Text(model.passwordErrorMessage).foregroundColor(.red)) {
                    passwordView
                }
                Section {
                    Button("Log In") {
                        shouldDismiss = true
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .disabled(!model.isValid)
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

