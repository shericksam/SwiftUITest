//
//  ColorConverter.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI

extension Color {
    static func color(from name: String) -> Color {
        let colorDictionary: [String: Color] = [
            "white": .white,
            "blue": .blue,
            "brown": .brown,
            "purple": .purple,
            "gray": .gray,
            "green": .green,
            "yellow": .yellow,
            "red": .red,
            "black": .gray,
            "pink": .pink
        ]

        return colorDictionary[name.lowercased()] ?? .clear
    }

    func convertToLigthColor(opacity: Double = 0.5) -> Color {
         let uiColor = UIColor(self)
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0

        uiColor.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)

        let whiteComponent = 1.0 - opacity
        let pastelRed = redComponent * whiteComponent + opacity
        let pastelGreen = greenComponent * whiteComponent + opacity
        let pastelBlue = blueComponent * whiteComponent + opacity

        return Color(red: Double(pastelRed), green: Double(pastelGreen), blue: Double(pastelBlue), opacity: 1.0)
    }

}
