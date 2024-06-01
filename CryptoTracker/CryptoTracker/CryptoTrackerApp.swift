//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {

    @StateObject private var homeViewModel = CompositionRoot.createHomeViewModel()

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

class CompositionRoot {
    static func createHomeViewModel() -> HomeViewModel {
        let networkManager = NetworkManager()
        let dataService = CoinDataService(networkManager: networkManager)
        let marketDataService = MarketDataService(networkManager: networkManager)
        return HomeViewModel(dataService: dataService, marketDataService: marketDataService)
    }
}
