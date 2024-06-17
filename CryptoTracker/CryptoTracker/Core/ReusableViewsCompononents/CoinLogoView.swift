//
//  CoinLogoView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 07/06/2024.
//

import SwiftUI
import Kingfisher

struct CoinLogoView: View {
    @State var isDetailView: Bool = false
    let coin: CoinModel

    var body: some View {
        if !isDetailView {
            VStack {
                KFImage(URL(string: coin.image))
                    .resizable()
                    .frame(width: 50, height: 50)
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundStyle(Color.theme.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(coin.name)
                    .font(.caption)
                    .foregroundStyle(Color.theme.secondaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)

            }
        } else {
            KFImage(URL(string: coin.image))
                .resizable()
//                .frame(width: 50, height: 50)

        }
    }
}

struct CoinLogoView_Preview: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
