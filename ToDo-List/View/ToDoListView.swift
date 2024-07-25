//
//  ToDoListView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import FirebaseFirestoreSwift
import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel: ToDoListViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    //put userId into todolistviewmodel.
    init(userId: String) {
        // users/<id>/ToDos/<entries>
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/ToDos")
        self._viewModel = StateObject(
            wrappedValue: ToDoListViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    ListItemView(item: item)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Reminder List")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: String("plus.circle.fill"))
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPressented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview("English") {
    ToDoListView(userId: "USER ID NUMBER")
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Español") {
    ToDoListView(userId: "USER ID NUMBER")
        .environment(\.locale, Locale(identifier: "ES"))
}
