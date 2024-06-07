//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by Omar Altali on 07/06/2024.
//

import SwiftUI

struct XMarkButton: View {
    @Binding var isPresented: Bool

    var body: some View {
        Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton(isPresented: .constant(true))
}
