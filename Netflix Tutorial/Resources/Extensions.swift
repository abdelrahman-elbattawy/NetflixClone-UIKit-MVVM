//
//  Extensions.swift
//  Netflix Tutorial
//
//  Created by Aboody on 07/07/2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
