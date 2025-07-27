//
//  JSONPlaceholderService.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import Combine

class JSONPlaceholderService: ObservableObject {
    static let shared = JSONPlaceholderService()
    
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else{
            throw JSONPlaceholderError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let users = try JSONDecoder().decode([User].self, from: data)
        return users
    }
    
    func validateLogin(identifier: String, password: String, users: [User]) -> User? {
        return users.first { user in
            let expectedPassword = (user.name + user.username).replacingOccurrences(of: " ", with: "")
            let matchesUsername = user.username.lowercased() == identifier.lowercased()
            let matchesEmail = user.email.lowercased() == identifier.lowercased()
            let correctPassword = expectedPassword.lowercased() == password.lowercased()
            
            return (matchesUsername || matchesEmail) && correctPassword
        }
    }
}

enum JSONPlaceholderError: Error {
    case invalidURL
    case invalidCredentials
}
