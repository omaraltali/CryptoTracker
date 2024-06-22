//
//  String.swift
//  CryptoTracker
//
//  Created by Omar Altali on 22/06/2024.
//

import Foundation

extension String {

    var removingHTMLfromString: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
