//
//  Info.swift
//  CryptoTracker
//
//  Created by Omar Altali on 27/06/2024.
//

import SwiftUI

struct InfoView: View {

    @Binding var isPresented: Bool

    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://youtube.com/c/swiftfulthinking")!
    let linkedInURL = URL(string: "https://www.linkedin.com/in/omar-altali-a48b01174/")!
    let coingeckoURL = URL(string: "https://coingecko.com")!
    let personalURL = URL(string: "")
    let coffeURL = URL(string: "https://buymeacoffee.com/nicksarno")!

    var body: some View {
        NavigationView {
            List {
                developerSection
                swiftfulThinkingSection
                coinGeckoSection

            }
            .listStyle(.grouped)
            .font(.headline)
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton(isPresented: $isPresented)
                }
            }
        }
    }
}

#Preview {
    InfoView(isPresented: .constant(true))
}


extension InfoView {

    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking Course on Youtube !. it uses MVVM Archeticture, Combine and Core Date ! , me as Omar added my touch while following the course to ......... ")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding()
            Link("Subscribe on Youtube 🫡",destination: youtubeURL)
                .foregroundStyle(Color.blue)
            Link("Support his coffe addiction ☕️", destination: coffeURL)
                .foregroundStyle(Color.blue)
        } header: {
            Text("Swiftful Thinking")
        }

    }

    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko !")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding()
            Link("Visit CoinGecko 🦎",destination: youtubeURL)
                .foregroundStyle(Color.blue)
        } header: {
            Text("coin gecko")
        }
    }

    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Omar Altali. It uses SwiftUI and is written ...... the project benfits from multi-threading, publishers/subscribers and data persitance")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding()
            Link("Visit CoinGecko 🤙🏻",destination: youtubeURL)
                .foregroundStyle(Color.blue)
        } header: {
            Text("Developer")
        }
    }
}

