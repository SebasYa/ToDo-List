//
//  ListItemViewmodel.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

// ViewModel for single to do list item view.

class ListItemViewmodel: ObservableObject {
    init() {}
    
    func toggleIsDone(item: ToDoListItem) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dataBase = Firestore.firestore()
        dataBase.collection(String("users"))
            .document(uid)
            .collection(String("ToDos"))
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
}
