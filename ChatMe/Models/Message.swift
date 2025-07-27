//
//  Message.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import FirebaseFirestore

struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    let senderId: String
    let senderName: String
    let receiverId: String
    let content: String
    let timestamp: Date
    var isRead: Bool = false
    
    init(senderId: String, senderName: String, receiverId: String, content: String, timestamp: Date = Date()) {
        self.senderId = senderId
        self.senderName = senderName
        self.receiverId = receiverId
        self.content = content
        self.timestamp = Date()
    }
}
