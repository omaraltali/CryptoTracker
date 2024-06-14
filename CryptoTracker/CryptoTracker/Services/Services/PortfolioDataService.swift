//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Omar Altali on 14/06/2024.
//

import Foundation
import CoreData

class PortfolioDataService {

    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "Portfolio"

    @Published var savedEntites: [Portfolio] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error Loading from Core Data \(error)")
            }
            self.getPortfolio()
        }
    }

    //MARK: PUBLIC

    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already exist in portfolio
        if let entity = savedEntites.first(where: {$0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }


    // MARK: PRIVATE

    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        if let savedEntites = try? container.viewContext.fetch(request) {
            self.savedEntites = savedEntites
        }
    }

    private func add(coin: CoinModel, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
    }

    private func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    private func delete(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }

    private func applyChanges() {
        save()
        getPortfolio()
    }
}
