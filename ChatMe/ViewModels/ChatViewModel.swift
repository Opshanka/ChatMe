//
//  ChatViewModel.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading: Bool = false
    
    private let firebaseService = FirebaseService.shared
    private var cancellables = Set<AnyCancellable>()
    private var chatId: String = ""
    
    func setupChat(currentUser: User, otherUser: User) async {
        do {
            chatId = try await firebaseService.createOrGetChat(
                between: String(currentUser.id),
                and: String(otherUser.id),
                user1Name: currentUser.name,
                user2Name: otherUser.name
            )
            subscribeToMessages()
        } catch {
            print("Error setting up chat: \(error)")
        }
    }
    
    private func subscribeToMessages() {
        firebaseService.fetchMessages(for: chatId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("Error fetching messages: \(failure)")
                }
            }, receiveValue: { [weak self] messages in
                self?.messages = messages
            })
            .store(in: &cancellables)
    }
    
    func sendMessage(from currentUser: User, to otherUser: User ) async{
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = Message(
            senderId: String(currentUser.id), senderName: currentUser.name, receiverId: String(otherUser.id), content: messageText
        )
        
        do {
            try await firebaseService.sendMessage(message, chatId: chatId)
            messageText = ""
        } catch {
            print("Error sending message: \(error)")
        }
    }
}
