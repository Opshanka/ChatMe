//
//  ChatView.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import SwiftUI

struct ChatView: View {
    
    let currentUser: User
    let otherUser : User
    
    @StateObject var chatViewModel : ChatViewModel = ChatViewModel()
    
    var body: some View{
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing : 8) {
                        ForEach(chatViewModel.messages) { message in
                            MessageBubbleView(
                                message: message, isCurrentUser: message.senderId == String(currentUser.id)
                            )
                            .id(message.id)
                        }
                    }
                }
                .onChange(of: chatViewModel.messages.count) { _ in
                    if let lastMessage = chatViewModel.messages.last {
                        withAnimation (.easeInOut(duration: 0.3)){
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                    
            }
            .padding()
            
            MessageInputView(messageText: $chatViewModel.messageText, onSend: {
                Task {
                    await chatViewModel.sendMessage(from: currentUser, to: otherUser)
                }
            })
        }
        .navigationTitle(otherUser.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await chatViewModel.setupChat(currentUser: currentUser, otherUser: otherUser)
        }
    }
    
    
}

struct MessageBubbleView : View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            VStack (alignment: isCurrentUser ? .trailing : .leading, spacing: 4){
                if !isCurrentUser {
                    Text(message.senderName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Text(message.content)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isCurrentUser ? .blue : Color.gray.opacity(0.2))
                    .foregroundStyle(isCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

struct MessageInputView: View {
    @Binding var messageText: String
    let onSend: () -> Void
    
    var body: some View {
        HStack {
            TextField("Type a message..", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onSend){
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.blue)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
}
