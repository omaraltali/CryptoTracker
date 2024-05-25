//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct HomeView: View {

    @State private var showProtfolio: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            // content
            VStack {
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
                .padding(.horizontal)
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
