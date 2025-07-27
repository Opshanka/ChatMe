//
//  LoginView.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import SwiftUI

struct LoginView : View {
    @EnvironmentObject var authViewModel : AuthViewModel
    
    @State private var identifier : String = ""
    @State private var password : String = ""
    
    var body: some View {
           
            VStack (spacing: 20) {
                Text("Chat Me")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Username or Email", text: $identifier)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text(authViewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        Task {
                            await authViewModel.login(identifier: identifier, password: password)
                        }
                    } label: {
                        VStack {
                            if authViewModel.isLoading {
                                ProgressView()
                            }
                            else {
                                Text("Login")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        
                    }
                    .disabled(authViewModel.isLoading || identifier.isEmpty || password.isEmpty)
                    
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 5) {
                                    Text("Demo Credentials:")
                                        .font(.headline)
                                    Text("Username: bret or Email: Sincere@april.biz")
                                        .font(.caption)
                                        .onTapGesture {
                                            UIPasteboard.general.string = "Bret"
                                        }
                                    Text("Password: LeanneGrahamBret")
                                        .font(.caption)
                                        .onTapGesture {
                                            UIPasteboard.general.string = "LeanneGrahamBret"
                                        }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                               
                VStack(alignment: .leading, spacing: 5) {
                    Text("Demo Credentials:")
                        .font(.headline)
                    Text("Username: Antonette or Email: Shanna@melissa.tv")
                        .font(.caption)
                        .onTapGesture {
                            UIPasteboard.general.string = "Antonette"
                        }
                    Text("Password: ErvinHowellAntonette")
                        .font(.caption)
                        .onTapGesture {
                            UIPasteboard.general.string = "ErvinHowellAntonette"
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                                
                                Spacer()
                
            }
            .padding()
            .fullScreenCover(isPresented: $authViewModel.isLoggedIn){
                MainTabView(currentUser: authViewModel.currentUser!).environmentObject(authViewModel)
            }
        
    }
}
