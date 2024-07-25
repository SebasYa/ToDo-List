//
//  ListItemView.swift
//  ToDo-List
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct ListItemView: View {
    
    @StateObject var viewModel = ListItemViewmodel()
    let item: ToDoListItem
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button {
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? String("checkmark.circle.fill") : String("circle"))
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    ListItemView(item:
            .init(id: "123",
                  title: "Juega Huracán",
                  dueDate: Date().timeIntervalSince1970,
                  createDate: Date().timeIntervalSince1970,
                  isDone: true))
}
