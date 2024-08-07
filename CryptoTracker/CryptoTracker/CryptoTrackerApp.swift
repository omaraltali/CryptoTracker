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
    @State private var showLaunchView: Bool = true

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some Scene {
        WindowGroup {
            ZStack {

                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(homeViewModel)

                ZStack {
                    if showLaunchView {
                        FakeLuanchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}

class CompositionRoot {
    private static let networkSharedInstance = NetworkManager.shared

    static func createHomeViewModel() -> HomeViewModel {
        let dataService = CoinDataService(networkManager: networkSharedInstance)
        let marketDataService = MarketDataService(networkManager: networkSharedInstance)
        let portfolioDataService = PortfolioDataService()
        return HomeViewModel(dataService: dataService, marketDataService: marketDataService, portfolioDataService: portfolioDataService)
    }

    static func createDetailViewModel(for coin: CoinModel) -> DetailViewModel {
        let coinDetailService = CoinDetailDataService(networkManager: networkSharedInstance, coin: coin)
        return DetailViewModel(coin: coin, coinDetailService: coinDetailService)
    }
}
