//
//  ToDoListViewModel.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import FirebaseFirestore
import Foundation

// ViewModel for list of items view

class ToDoListViewModel: ObservableObject {
    
    @Published var showingNewItemView = false
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func delete(id: String) {
        let dataBase = Firestore.firestore()
        
        dataBase.collection(String("users"))
            .document(userId)
            .collection(String("ToDos"))
            .document(id)
            .delete()
    }
}
