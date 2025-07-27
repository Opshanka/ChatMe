//
//  FirebaseService.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseFirestoreCombineSwift

class FirebaseService : ObservableObject{
    static let shared = FirebaseService()
    let db = Firestore.firestore()
    
    let chatCollection = "chats"
    let userCollection = "users"
    let messagesCollection = "messages"
    
    // User crud
    func createOrUpdateUser(_ user: User) async throws {
        try await db.collection(userCollection).document(String(user.id)).setData(from: user, merge: true)
    }
    
    func updateUserOnlineStatus(userId: String, isOnline: Bool) async throws {
        try await db.collection(userCollection).document(userId).updateData(["isOnline" : isOnline, "lastSeen" : Date()])
    }
    
    func fetchAllUsers() async throws -> [User] {
        let snapshot = try await db.collection(userCollection).getDocuments()
        return snapshot.documents.compactMap{ document in
                try? document.data(as: User.self)
        }
    }
    
    func createOrGetChat(between user1Id: String, and user2Id: String, user1Name: String, user2Name: String) async throws -> String {
        let participants = [user1Id, user2Id].sorted()
        let chatId = participants.joined(separator: "_")
        
        let chatRef = db.collection(chatCollection).document(chatId)
        let chatDoc = try await chatRef.getDocument()
        
        if !chatDoc.exists {
            let newChat = Chat (
                participants: participants, participantNames: [user1Id: user1Name, user2Id: user2Name]
            )
            try await chatRef.setData(from: newChat)
        }
        
        return chatId
    }
    
    func sendMessage(_ message : Message, chatId: String) async throws {
        
        try await db.collection(chatCollection).document(chatId)
            .collection(messagesCollection)
            .addDocument(from: message)
        
        try await db.collection(chatCollection).document(chatId).updateData([
            "lastMessage" : message.content,
            "lastMessageTime" : message.timestamp
        ])
    }
    
    func fetchMessages(for chatId: String) -> AnyPublisher<[Message], Error> {
        return db.collection("chats").document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .snapshotPublisher()
            .map { snapshot in
                snapshot.documents.compactMap { document in
                    try? document.data(as: Message.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUserChats(for userId: String) -> AnyPublisher<[Chat], Error> {
        return db.collection(chatCollection)
            .whereField("participants", arrayContains: userId)
            .order(by: "lastMessageTime", descending: true)
            .snapshotPublisher()
            .map { snapshot in
                snapshot.documents.compactMap { document in
                    try? document.data(as : Chat.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
   
}

extension FirebaseService {
    func isUserCollectionEmpty() async throws -> Bool {
        let snapshot = try await db.collection(userCollection)
            .limit(to: 1)
            .getDocuments()
        return snapshot.documents.isEmpty
    }
    
    func exportAllUserToFirestoreFromJSONResponseIfNeeded() async {
        do {
            guard try await isUserCollectionEmpty() else {
                return
            }
            let users = try await JSONPlaceholderService.shared.fetchUsers()
            for user in users {
                            try await createOrUpdateUser(user)
                        }
            print("✅ Seeded \(users.count) users into Firebase.")
        }
        catch {
            print("Invalid snapshot")
        }
    }
    
}

extension Query {

   
    
    func snapshotPublisher() -> AnyPublisher<QuerySnapshot, Error> {
        let publisher = PassthroughSubject<QuerySnapshot, Error>()
        
        let listener = self.addSnapshotListener { snapshot, error in
            if let error = error {
                publisher.send(completion: .failure(error))
            } else if let snapshot = snapshot {
                publisher.send(snapshot)
            }
        }
        
        return publisher
            .handleEvents(receiveCancel: {
                listener.remove()
            })
            .eraseToAnyPublisher()
    }
    
   
}
