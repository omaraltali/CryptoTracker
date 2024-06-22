//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {

    @Published var overviewStastics: [StatisticModel] = []
    @Published var additionalStastics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil


    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel, coinDetailService: CoinDetailDataService) {
        self.coinDetailService = coinDetailService
        self.coin = coin
        addSubscribers()
    }

    private func addSubscribers() {

        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink {[weak self] returnedArrays in
                self?.overviewStastics = returnedArrays.overview
                self?.additionalStastics = returnedArrays.additional
            }
            .store(in: &cancellables)

        coinDetailService.$coinDetails.sink {[weak self] coinDetail in
            guard let self, let coinDetail else {return}
            self.coinDescription = coinDetail.description?.en
            self.websiteURL = coinDetail.links?.homepage?.first
            self.redditURL = coinDetail.links?.subredditURL
        }
        .store(in: &cancellables)

    }

    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let overviewArray = createOverViewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)

        return(overviewArray,additionalArray)
    }

    private func createOverViewArray(coinModel: CoinModel) -> [StatisticModel] {

        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentCahnge = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentCahnge)

        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapstat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)


        let overviewArray: [StatisticModel] = [
            priceStat, marketCapstat, rankStat, volumeStat
        ]

        return overviewArray

    }

    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {

        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let hightStat = StatisticModel(title: "24h High", value: high)

        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = StatisticModel(title: "24h Low", value: low)

        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H

        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)

        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel?.hashingAlgorithm ?? "N/A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        let additionalArray: [StatisticModel] = [
            hightStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]

        return additionalArray

    }

}
