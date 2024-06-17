//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import SwiftUI

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel
    private let collumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)

                overviewTitle
                Divider()
                overViewGrid
                additionalTitle
                Divider()
                additionalGrid

            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
}

extension DetailView {

    private var overviewTitle: some View {
        Text("Ovewview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)
    }

    private var overViewGrid: some View {
        LazyVGrid(columns: collumns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(viewModel.overviewStastics) { stat in
                StatsisticView(stat: stat)

            }
            .padding(.leading, 5)

        })

    }

    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)

    }

    private var additionalGrid: some View {
        LazyVGrid(columns: collumns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(viewModel.additionalStastics) { stat in
                StatsisticView(stat: stat)

            }
            .padding(.leading, 5)

        })
    }

    private var navigationBarTrailingItem: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
            .foregroundStyle(Color.theme.secondaryText)

            CoinLogoView(isDetailView: true, coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: CompositionRoot.createDetailViewModel(for: dev.coin))
        }
    }
}


