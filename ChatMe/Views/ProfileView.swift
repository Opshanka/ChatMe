//
//  ProfileView.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//


import SwiftUI

struct ProfileView: View {
    let currentUser: User
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(currentUser.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(currentUser.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: currentUser.isOnline ? "dot.circle.fill" : "dot.circle")
                        .foregroundColor(currentUser.isOnline ? .green : .gray)
                    Text(currentUser.isOnline ? "Online" : "Offline")
                        .font(.caption)
                        .foregroundColor(currentUser.isOnline ? .green : .secondary)
                }
                
                Text("Last seen: \(formattedDate(currentUser.lastSeen))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 40)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
