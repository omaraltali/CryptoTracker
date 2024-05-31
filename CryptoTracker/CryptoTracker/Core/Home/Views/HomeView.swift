//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showProtfolio: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                homeHeader
                coloumnTitles

                if !showProtfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }

                if showProtfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeViewModel)
    }
}


extension HomeView {

    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconeName: showProtfolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showProtfolio)
                )
            Spacer()
            Text(showProtfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconeName: "chevron.right")
                .rotationEffect(.degrees(showProtfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showProtfolio.toggle()
                    }
                }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

    private var coloumnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showProtfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }


    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRawView(coin: coin, showHoldingsColoumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)

    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRawView(coin: coin, showHoldingsColoumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }


}
