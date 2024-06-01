//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    private var cancellables: Set<AnyCancellable> = []

    let dataService: CoinDataService

    init(dataService: CoinDataService) {
        self.dataService = dataService
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
            .combineLatest(dataService.$allCoins)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { text, initialCoins -> [CoinModel] in
                guard !text.isEmpty else {
                    return initialCoins
                }

                let lowercasedText = text.lowercased()
               return initialCoins.filter {
                    $0.name.lowercased().contains(lowercasedText) ||
                    $0.symbol.lowercased().contains(lowercasedText) ||
                    $0.id.lowercased().contains(lowercasedText)
                }
            }
            .sink {[weak self] filteredCoinsReturned in
                self?.allCoins = filteredCoinsReturned
            }
            .store(in: &cancellables)
    }
}
