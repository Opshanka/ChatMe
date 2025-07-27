//
//  User.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import FirebaseFirestore

struct User : Identifiable, Codable, Hashable {
    let id: Int
    let name : String
    let username: String
    let email: String
    var isOnline: Bool = false
    var lastSeen: Date = Date()
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case username
        case email
        case isOnline
        case lastSeen
    }
    
    init(from decorder: Decoder) throws {
        let container = try decorder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.username = try container.decode(String.self, forKey: .username)
        self.isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline) ?? false
        self.lastSeen = try container.decodeIfPresent(Date.self, forKey: .lastSeen) ?? Date()
    }
}

