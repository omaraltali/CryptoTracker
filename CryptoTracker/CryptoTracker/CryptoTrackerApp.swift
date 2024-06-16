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

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}

class CompositionRoot {

   static let networkManager = NetworkManager()

    static func createHomeViewModel() -> HomeViewModel {
        let dataService = CoinDataService(networkManager: networkManager)
        let marketDataService = MarketDataService(networkManager: networkManager)
        let portfolioDataService = PortfolioDataService()
        return HomeViewModel(dataService: dataService, marketDataService: marketDataService, portfolioDataService: portfolioDataService)
    }

    static func createDetailViewModel(for coin: CoinModel) -> DetailViewModel {
        let coinDetailService = CoinDetailDataService(networkManager: networkManager, coin: coin)
        return DetailViewModel(coin: coin, coinDetailService: coinDetailService)
    }
}
