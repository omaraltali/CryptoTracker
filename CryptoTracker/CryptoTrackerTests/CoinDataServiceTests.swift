//
//  CoinDataServiceTests.swift
//  CryptoTrackerTests
//
//  Created by Omar Altali on 31/05/2024.
//

import XCTest
import Combine
@testable import CryptoTracker

final class CoinDataServiceTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testGetCoinsSuccess() {
        let coins = [CoinModel(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "", currentPrice: 50000, marketCap: 1000000, marketCapRank: 1, fullyDilutedValuation: nil, totalVolume: 50000, high24H: 60000, low24H: 40000, priceChange24H: 5000, priceChangePercentage24H: 10, marketCapChange24H: 100000, marketCapChangePercentage24H: 10, circulatingSupply: 10000, totalSupply: 10000, maxSupply: 21000, ath: 60000, athChangePercentage: -10, athDate: "", atl: 100, atlChangePercentage: 49000, atlDate: "", lastUpdated: "", sparklineIn7D: nil, priceChangePercentage24HInCurrency: nil, currentHoldings: nil)]
        let fetchDataResult = Just(coins)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let dataService = makeSUT(fetchDataResult: fetchDataResult)

        let expectation = XCTestExpectation(description: "All coins are published")
        dataService.fetchCoins()
            .sink { receivedCoins in
                XCTAssertEqual(receivedCoins.count, 1)
                XCTAssertEqual(receivedCoins.first?.name, "Bitcoin")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetCoinsFailure() {
        let error = URLError(.badServerResponse)
        let fetchDataResult = Fail<[CoinModel], Error>(error: error).eraseToAnyPublisher()

        let dataService = makeSUT(fetchDataResult: fetchDataResult)

        let expectation = XCTestExpectation(description: "Error is handled")
        dataService.fetchCoins()
            .sink { receivedCoins in
                XCTAssertTrue(receivedCoins.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }


    // MARK: Helpers

    private func makeSUT(fetchDataResult: AnyPublisher<[CoinModel], Error>) -> CoinDataService {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.fetchDataResult = fetchDataResult
        let dataService = CoinDataService(networkManager: mockNetworkManager)
        return dataService
    }
}
