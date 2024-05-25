//
//  CoinRawView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct CoinRawView: View {

    let coin: CoinModel
    let showHoldingsColoumn: Bool

    var body: some View {

        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
                Circle()
                .frame(width: 30, height: 30)

            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
                Spacer()

            if showHoldingsColoumn {
                VStack(alignment: .trailing) {
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .bold()
                    Text((coin.currentHoldings ?? 0).asNumberString())
                }.foregroundColor(Color.theme.accent)
            }
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "0")
                    .foregroundStyle(
                        coin.priceChangePercentage24H ?? 0 >= 0
                        ? Color.theme.green
                        : Color.theme.red)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

        }
        .font(.subheadline)
    }
}

struct CoinRawView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRawView(coin: dev.coin, showHoldingsColoumn: true)
            .previewLayout(.sizeThatFits)
    }
}
