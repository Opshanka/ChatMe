//
//  UserListView.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//
import SwiftUI
struct UserListView : View {
    let currentUser : User
    @StateObject var userListViewModel = UserListViewmodel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userListViewModel.users.filter { $0.id != currentUser.id }) { user in
                    
                    NavigationLink ( destination : ChatView (currentUser: currentUser, otherUser: user)){
                        UserRow(user: user)
                    }
                }
                
            }
            .navigationTitle("Users")
            .refreshable {
                await userListViewModel.loadingUsers()
            }
        }
        .task {
            await userListViewModel.loadingUsers()
        }
    }
}


struct UserRow : View {
    let user : User
    var body: some View {
        HStack{
            Circle()
                .fill(user.isOnline ? Color.green : Color.gray)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 2){
                Text(user.name)
                    .font(.headline)
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if !user.isOnline {
                    Text("Last seen: \(user.lastSeen, style: .relative) ago")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                else {
                    Text("Online")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
            }
            Spacer()
        }
        .padding(.vertical, 2)
    }
}
