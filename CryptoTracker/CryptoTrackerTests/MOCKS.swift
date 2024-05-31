//
//  MOCKS.swift
//  CryptoTrackerTests
//
//  Created by Omar Altali on 31/05/2024.
//

import Foundation
import Combine
@testable import CryptoTracker

class MockNetworkManager: NetworkManagerProtocol {

    var fetchDataResult: AnyPublisher<[CoinModel], Error>!

    func fetchData<T>(from url: URL, type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        return fetchDataResult as! AnyPublisher<T, Error>
    }
}

