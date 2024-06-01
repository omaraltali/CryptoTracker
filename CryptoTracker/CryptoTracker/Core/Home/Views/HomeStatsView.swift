//
//  HomeStatsView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 01/06/2024.
//

import SwiftUI

struct HomeStatsView: View {

    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(homeViewModel.statistics) { stat in
                StatsisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(HomeViewModel(dataService: CoinDataService(networkManager: NetworkManager()), marketDataService: MarketDataService(networkManager: NetworkManager())))
}
