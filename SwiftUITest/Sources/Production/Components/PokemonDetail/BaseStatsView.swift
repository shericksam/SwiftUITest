//
//  BaseStatsView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI

struct BaseStatsView: View {
    let baseStatsTotal: Int
    let baseStats: StatsModel

    var body: some View {
        VStack {
            Text("Base Stats Total: \(baseStatsTotal)")
                .font(.headline)
                .padding()

            Text("HP: \(String(baseStats.hp))")
            Text("Attack: \(String(baseStats.attack))")
            Text("Defense: \(String(baseStats.defense))")
            Text("Special Attack: \(String(baseStats.specialattack))")
            Text("Special Defense: \(String(baseStats.specialdefense))")
            Text("Speed: \(String(baseStats.speed))")
        }
    }
}
