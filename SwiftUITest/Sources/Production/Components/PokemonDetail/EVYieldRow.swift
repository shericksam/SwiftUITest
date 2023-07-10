//
//  EVYieldRow.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI

struct EVYieldRow: View {
    let statName: String
    let yieldValue: Int

    var body: some View {
        HStack {
            Text(statName)

            Spacer()

            Text("+\(yieldValue)")
                .foregroundColor(.green)
        }
        .padding(.vertical, 4)
    }
}
