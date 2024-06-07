//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 01/06/2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                    coinLogoList

                }
                .navigationTitle("Edit Portfolio")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        XMarkButton(isPresented: $isPresented)
                    }
                })
            }
        }
    }
}


extension PortfolioView {

    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ?
                                    Color.theme.green : Color.clear,
                                        lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(isPresented: .constant(true))
            .environmentObject(dev.homeViewModel)
    }
}
