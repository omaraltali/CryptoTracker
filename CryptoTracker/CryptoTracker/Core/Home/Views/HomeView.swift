//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            VStack {
                Text("Header")
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}
