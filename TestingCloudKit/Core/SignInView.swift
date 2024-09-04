//
//  SignInView.swift
//  TestingCloudKit
//
//  Created by thaxz on 04/09/24.
//

import SwiftUI
import AuthenticationServices
import CloudKit

struct SignInView: View {
    
    @EnvironmentObject var ckManager: CKManager
    
    var body: some View {
        VStack{
            SignInWithAppleButton(.signIn) { request in
                // faz o request aqui
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                // se der sucesso ou falhar
                switch result {
                case  .success(let authorization):
                    handleSuccess(with: authorization)
                case .failure(let error):
                    handleError(error)
                }
            }
            .frame(height: 45)
            .padding()
        }
        
    }
}

extension SignInView {
    
    func handleSuccess(with authorization: ASAuthorization) {
        
        guard let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userID = userCredential.user
        
        Task {
            do {
                if let name = userCredential.fullName?.givenName,
                   let emailAddr = userCredential.email {
                    // Usuário novo, salvar no CloudKit
                    try await ckManager.addUser(userID: userID, name: name, email: emailAddr)
                    print("User saved successfully!")
                } else {
                    // Usuário já existente, buscar no CloudKit
                    if let userRecord = try await ckManager.fetchUser(userID: userID) {
                        let name = userRecord["name"] as? String ?? "No name"
                        let email = userRecord["email"] as? String ?? "No email"
                        print("User found: \(name), \(email)")
                    } else {
                        print("No user found with ID: \(userID)")
                    }
                }
            } catch {
                print("Failed to handle user: \(error.localizedDescription)")
            }
        }
    }
    
    func handleError(_ error: Error) {
        print("Could not authenticate: \(error.localizedDescription)")
    }
}

#Preview {
    SignInView()
}
