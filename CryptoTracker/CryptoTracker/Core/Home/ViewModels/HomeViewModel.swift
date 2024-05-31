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
    private var cancellables: Set<AnyCancellable> = []

    let dataService: CoinDataService

    init(dataService: CoinDataService) {
        self.dataService = dataService
        addSubscribers()
    }

    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] receivedCoins in
                self?.allCoins = receivedCoins
            }
            .store(in: &cancellables)
    }
}
