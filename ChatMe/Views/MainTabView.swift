//
//  MainTabView.swift
//  ChatMe
//
//  Created by Opshanka Prabath on 2025-07-27.
//

import SwiftUI

struct MainTabView : View {
    let currentUser : User
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        TabView {
            UserListView(currentUser: currentUser)
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Users")
                }
            
            ProfileView(currentUser: currentUser)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}
