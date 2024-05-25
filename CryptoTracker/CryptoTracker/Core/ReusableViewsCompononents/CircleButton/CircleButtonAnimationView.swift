//
//  CircleButtonAnimationView.swift
//  CryptoTracker
//
//  Created by Omar Altali on 25/05/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {

    @Binding  var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1.0) : .none )
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(true))
        .foregroundColor(Color.theme.red)
}
