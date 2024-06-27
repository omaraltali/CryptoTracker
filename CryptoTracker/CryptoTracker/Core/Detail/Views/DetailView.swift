//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import SwiftUI

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel
    @State private var showFullDescription: Bool = false
    private let collumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                overviewTitle
                Divider()
                descriptionSection
                overViewGrid
                additionalTitle
                Divider()
                additionalGrid
                websiteSection

            }

        }
        .navigationTitle(viewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
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

    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .foregroundStyle(Color.blue)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = viewModel.websiteURL, let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }

            if let redditString = viewModel.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .padding(.horizontal, 4)
        .foregroundStyle(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: CompositionRoot.createDetailViewModel(for: dev.coin))
        }
    }
}


