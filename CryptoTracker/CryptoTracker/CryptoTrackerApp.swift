//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {

    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
