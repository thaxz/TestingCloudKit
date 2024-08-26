//
//  TodoView.swift
//  TestingCloudKit
//
//  Created by thaxz on 24/08/24.
//

import SwiftUI

//TODO: Refactor mvvm
struct TodoView: View {
    @StateObject var viewModel: TodoViewModel = TodoViewModel()
    var body: some View {
        VStack(spacing: 24){
            TextField("O que você quer fazer?", text: $viewModel.textfieldText)
                .textFieldStyle(.roundedBorder)
            Button {
                viewModel.createTask()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 45)
                    Text("Criar tarefa")
                        .foregroundStyle(.white)
                }
            }
            List {
                ForEach(viewModel.tasks, id: \.recordId) { task in
                    TaskRow(taskModel: task, onUpdate: { editedTask in
                        viewModel.updateTask(editedTask)
                    })
                }.onDelete { indexSet in
                    viewModel.deleteTask(indexSet)
                }
            }
        }
        .padding(32)
        .onAppear{
            viewModel.fetchTaks()
        }
    }
}

#Preview {
    TodoView()
}
