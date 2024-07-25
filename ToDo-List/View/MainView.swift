//
//  MainView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        
        if viewModel.isSignIn, !viewModel.currentUserId.isEmpty {
           accounView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accounView: some View {
        TabView {
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: String("house"))
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: String("person.circle"))
                }
        }
    }
}

#Preview("English") {
    MainView()
        .environment(\.locale, Locale(identifier: "EN"))
}
#Preview("Español") {
    MainView()
        .environment(\.locale, Locale(identifier: "ES"))
}
