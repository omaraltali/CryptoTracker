//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Omar Altali on 01/06/2024.
//

import Foundation
import SwiftUI

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
