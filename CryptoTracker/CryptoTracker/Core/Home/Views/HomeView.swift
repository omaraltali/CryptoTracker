//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPorfolioSheetView: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPorfolioSheetView, content: {
                    PortfolioView(isPresented: $showPorfolioSheetView)
                        .environmentObject(viewModel)
                })
            VStack {
                homeHeader

                HomeStatsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $viewModel.searchText)

                coloumnTitles

                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }

                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
        .navigationDestination(for: CoinModel.self) { coin in
            DetailView(coin: coin)
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
            CircleButtonView(iconeName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPorfolioSheetView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconeName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
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
            if showPortfolio {
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
                NavigationLink(value: coin) {
                    EmptyView()
                }
                .opacity(0)
                .listRowInsets(EdgeInsets())
                .background(
                    CoinRawView(coin: coin, showHoldingsColoumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                )
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }

    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRawView(coin: coin, showHoldingsColoumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }


}
