//
//  NewItemView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewModel()
    @Binding var newItemPressented: Bool
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 50)
            
            Form{
                // TITLE
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // DUE DATE
                DatePicker(String("Due Date"), selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                // BUTTON
                TLButton(title: "Save",
                         background: .pink
                ) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPressented = false
                    } else {
                        viewModel.showAlert = true
                        
                    }
                    
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Error"),
                      message: Text("Please complete all fields and select today date or newer."))
            })
        }
    }
}

#Preview("English"){
    NewItemView(newItemPressented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
    .environment(\.locale, Locale(identifier: "EN"))
}
#Preview("Español"){
    NewItemView(newItemPressented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
    .environment(\.locale, Locale(identifier: "ES"))
}
