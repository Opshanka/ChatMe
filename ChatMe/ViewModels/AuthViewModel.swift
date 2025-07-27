//
//  AuthViewModel.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let jsonPlaceholderService = JSONPlaceholderService.shared
    private let firebaseService = FirebaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func login(identifier: String, password: String) async {
        isLoading = true
        defer {
            isLoading = false
        }
        errorMessage = ""
        
        do {
            let users = try await jsonPlaceholderService.fetchUsers()
            
            if let user = jsonPlaceholderService.validateLogin(identifier: identifier, password: password, users: users){
                var userWithOnlineStatus = user
                userWithOnlineStatus.isOnline = true
                
                try await firebaseService.createOrUpdateUser(userWithOnlineStatus)
                try await firebaseService.updateUserOnlineStatus(userId: String(user.id), isOnline: true)
                
                currentUser = userWithOnlineStatus
                isLoggedIn = true
            }
            else {
                errorMessage = "Invalid credentials"
            }
            
        } catch {
            errorMessage = "Login failed \(error.localizedDescription)"
        }
    }
    
    func logout() async{
        if let user = currentUser {
            try? await firebaseService.updateUserOnlineStatus(userId: String(user.id), isOnline: false)
        }
        currentUser = nil
        isLoggedIn = false
    }
    
}
