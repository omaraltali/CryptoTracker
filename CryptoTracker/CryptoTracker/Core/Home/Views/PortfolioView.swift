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
    @State private var quiantityText: String = ""
    @State private var showCheckMark: Bool = false
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                .navigationTitle("Edit Portfolio")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        XMarkButton(isPresented: $isPresented)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        trailingNavBarButtons
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

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.5", text: $quiantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .font(.headline)
        .padding()

    }

    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity( (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quiantityText)) ? 1.0 : 0.0
            )
        }
        .font(.headline)

    }

    private func getCurrentValue() -> Double {
        if let quiantity = Double(quiantityText) {
            return quiantity * (selectedCoin?.currentPrice ?? 0)
        } else {
          return  0
        }
    }

    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }

        // perform saving

        withAnimation(.easeIn) {
            showCheckMark = true
        }

        UIApplication.shared.endEditing()
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(isPresented: .constant(true))
            .environmentObject(dev.homeViewModel)
    }
}
