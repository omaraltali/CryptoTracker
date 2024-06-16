//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 16/06/2024.
//

import SwiftUI

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        Text(viewModel.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: CompositionRoot.createDetailViewModel(for: dev.coin))
    }
}
