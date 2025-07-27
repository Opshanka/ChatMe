//
//  UserListViewmodel.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//


import Foundation
import Combine

@MainActor
class UserListViewmodel: ObservableObject {
    @Published var users: [User] = []
    
    @Published var isLoading: Bool = false
    
    private let firebaseService = FirebaseService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func loadingUsers() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            users = try await firebaseService.fetchAllUsers()
        } catch {
            print("Error loading users: \(error)")
        }
    }
}
