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
        }
        .padding(32)
    }
}

#Preview {
    TodoView()
}
