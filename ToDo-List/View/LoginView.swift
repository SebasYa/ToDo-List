//
//  LoginView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // HEADER
                HeaderView(title: "To Do List", 
                           subtite: "Don´t remind, just tap",
                           angle: 19, background: Color(String("HeadColor")))
                
                // LOGIN FORM
                
                
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    TLButton(
                        title: "Log In",
                        background: Color("LoginColor")
                    ) {
                        // Try to log in
                        viewModel.login()
                    }
                }
                .offset(y: -50)
                
                
                // CREATE ACCOUNT
                VStack {
                    Text("New around here?")
                    NavigationLink(destination: RegisterView()) {
                        HStack{
                            Image(systemName: String("person.fill.badge.plus"))
                            Text("Create New Account")
                        }
                        .padding(.trailing)
                    }
                }
                
                .padding(.top, 110)
//                Spacer()
                
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}



#Preview("English") {
    LoginView()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Español") {
    LoginView()
        .environment(\.locale, Locale(identifier: "ES"))
}
