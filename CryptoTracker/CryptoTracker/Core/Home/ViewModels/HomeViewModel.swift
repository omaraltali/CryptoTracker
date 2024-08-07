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

    private let coinDataService: CoinDataServiceProtocol
    private let marketDataService: MarketDataService
    private let portfolioDataService: PortfolioDataService

    init(dataService: CoinDataServiceProtocol, marketDataService: MarketDataService, portfolioDataService: PortfolioDataService) {
        self.coinDataService = dataService
        self.marketDataService = marketDataService
        self.portfolioDataService = portfolioDataService
        addSubscribers()
    }

    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.fetchCoins())
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map(filterCoins)
            .sink { [weak self] filteredCoinsReturned in
                self?.allCoins = filteredCoinsReturned
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map(mapAllCoinsToPortoflioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketDataToStatistics)
            .sink { [weak self] arrayOfStats in
                self?.statistics = arrayOfStats
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

    private func mapMarketDataToStatistics(_ marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        guard let data = marketData else {
            return []
        }

        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins.map{$0.currentHoldingsValue}
            .reduce(0, +)

        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }
            .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)

        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)

        return [marketCap, volume, btcDominance, portfolio]
    }

    private func mapAllCoinsToPortoflioCoins(allCoins: [CoinModel], portfolioEntities: [Portfolio]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    func reloadData() {
        coinDataService.fetchCoins()
            .assign(to: &$allCoins)
        marketDataService.getMarketData()
    }
}
