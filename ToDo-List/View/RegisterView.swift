//
//  RegisterView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            // HEADER
            HeaderView(title: "Register",
                       subtite: "let get things done!",
                       angle: -19,
                       background: Color(String("RegisterHeadColor")))
            
            Form {
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.sentences)
                
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                TLButton(
                    title: "Create Account",
                    background: Color(String("LoginColor"))
                ) {
                    // Attempt registration
                    viewModel.register()
                }
            }
            .padding(.bottom, 110)
            .offset(y: -60)
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview("English") {
    RegisterView()
        .environment(\.locale, Locale(identifier: "EN"))
}
#Preview("Español") {
    RegisterView()
        .environment(\.locale, Locale(identifier: "ES"))
}
