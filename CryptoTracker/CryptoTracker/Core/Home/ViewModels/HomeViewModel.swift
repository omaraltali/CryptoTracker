//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var statistics: [StatisticModel] = []

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    private var cancellables: Set<AnyCancellable> = []

    private let coinDataService: CoinDataService
    private let marketDataService: MarketDataService
    private let portfolioDataService: PortfolioDataService

    init(dataService: CoinDataService, marketDataService: MarketDataService, portfolioDataService: PortfolioDataService) {
        self.coinDataService = dataService
        self.marketDataService = marketDataService
        self.portfolioDataService = portfolioDataService
        addSubscribers()
    }

    func addSubscribers() {

        // MARK: Combine POWER
        // we get rid of this first subscribing since we combined sinking on $searchText and dataService.$allCoins
//        dataService.$allCoins
//            .sink { [weak self] receivedCoins in
//                self?.allCoins = receivedCoins
//            }
//            .store(in: &cancellables)

        // Subscribe to seachText :
        // and make the searchText also subscribe to data service $allCoins using combineLatest
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map(filterCoins)
            .sink {[weak self] filteredCoinsReturned in
                self?.allCoins = filteredCoinsReturned
            }
            .store(in: &cancellables)


        marketDataService.$marketData.map(mapMarketDataToStatistics)
        .sink {[weak self] arrayOfStats in
            self?.statistics = arrayOfStats
        }
        .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map { coinModels, portfolioEntites  -> [CoinModel] in
                coinModels.compactMap { coin -> CoinModel? in
                    guard let entity = portfolioEntites.first(where: {$0.coinID == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink {[weak self] returnedCoins  in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func filterCoins(searchText: String, coins: [CoinModel]) -> [CoinModel] {
        guard !searchText.isEmpty else {
            return coins
        }

        let lowercasedText = searchText.lowercased()
        return coins.filter {
            $0.name.lowercased().contains(lowercasedText) ||
            $0.symbol.lowercased().contains(lowercasedText) ||
            $0.id.lowercased().contains(lowercasedText)
        }
    }

    private func mapMarketDataToStatistics(_ marketData: MarketDataModel?) -> [StatisticModel] {
        guard let data = marketData else {
            return []
        }

        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)

        return [marketCap, volume, btcDominance, portfolio]
    }

    func reloadData() {
        coinDataService.getCoins()
    }




}
