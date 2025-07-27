//
//  Chat.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import FirebaseFirestore

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    let participants: [String]
    let participantnames: [String: String]
    var lastMessage: String
    var lastMessageTime: Date
    var unreadCount: [String: Int] = [:]
    
    init(participants: [String], participantNames: [String: String]) {
        self.participants = participants.sorted()
        self.participantnames = participantNames
        self.lastMessage = ""
        self.lastMessageTime = Date()
    }
}
