//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 01/06/2024.
//

import SwiftUI

struct SearchBarView: View {

    @State var searchText: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)

            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.5), radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView()
}
