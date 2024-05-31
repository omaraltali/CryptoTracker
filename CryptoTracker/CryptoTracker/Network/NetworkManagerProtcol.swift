//
//  NetworkManagerProtcol.swift
//  CryptoTracker
//
//  Created by Omar Altali on 31/05/2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(from url: URL, type: T.Type) -> AnyPublisher<T, Error>
}
