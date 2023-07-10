//
//  PokemonDetailView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var viewModel: PokemonListViewModel
    let pokemon: PokemonModel

    var body: some View {
        VStack {
            if let pokemon = viewModel.pokemonSelected {
                VStack {
                    if let sprite = pokemon.sprite, let url = URL(string: sprite) {
                        GIFImageViewRep(gifURL: url)
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fit)
                    }

                    Text("Species: \(pokemon.species?.localizedUppercase ?? "")")
                        .font(.headline)
                        .padding()

                    HStack {
                        if pokemon.isEggObtainable {
                            Text("Is Egg Obtainable: Yes")
                                .foregroundColor(.green)
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                                .font(.largeTitle)
                        } else {
                            Text("Is Egg Obtainable: No")
                                .foregroundColor(.red)
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.largeTitle)
                        }
                    }
                    Text("Height: \(pokemon.height.formatted) m")
                        .font(.subheadline)

                    Text("Weight: \(pokemon.weight.formatted) kg")
                        .font(.subheadline)

                    if let types = pokemon.types {
                        HStack {
                            ForEach(types) { type in
                                if let typeName = type.name {
                                    Text(typeName)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(PokemonColors.getColor(for: typeName))
                                        )
                                }
                            }
                        }
                    }

                    if let baseStats = pokemon.baseStats {
                        BaseStatsView(baseStatsTotal: pokemon.baseStatsTotal,
                                      baseStats: baseStats)
                    }
//                    if let evYields = pokemon.evYields {
//                        DisclosureGroup("EV Yields") {
//                            ForEach(evYields.propertyPairs(), id: \.key) { key, value in
//                                EVYieldRow(statName: key, yieldValue: value)
//                            }
//                        }
//                        .padding(.top, 16)
//                        .padding([.bottom, .horizontal])
//                    }
                    if let preevolutions = pokemon.preevolutions {
                        DisclosureGroup("Pre-Evolutions (\(preevolutions.count))") {
                            ForEach(preevolutions, id: \.num) { preevolution in
                                EvolutionView(evolution: preevolution)
                            }
                        }
                        .padding(.top, 16)
                        .padding([.bottom, .horizontal])
                    }

                    if let evolutions = pokemon.evolutions {
                        DisclosureGroup("Evolutions (\(evolutions.count))") {
                            ForEach(evolutions, id: \.num) { evolution in
                                EvolutionView(evolution: evolution)
                            }
                        }
                        .padding(.top, 16)
                        .padding([.bottom, .horizontal])
                    }

                    Spacer()
                }
                .navigationTitle(pokemon.species?.capitalized ?? "")
                .onAppear {
                    Task {
                        await viewModel.getPokemonSelected()
                    }
                }
            }
        }
        .onAppear {
            viewModel.pokemonSelected = pokemon
        }
    }
}

extension Float {
    var formatted: String {
        return String(format: "%.1f", self)
    }
}
struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let examplePokemon = PokemonModel(
            backSprite: "back_sprite",
            baseStatsTotal: 500,
            bulbapediaPage: "https://bulbapedia.com",
            color: "Red",
            evolutionLevel: "30",
            forme: "Forme",
            formeLetter: "A",
            height: 1.0,
            isEggObtainable: true,
            key: "123",
            legendary: false,
            num: 25,
            shinyBackSprite: "shiny_back_sprite",
            shinySprite: "shiny_sprite",
            species: "Pikachu",
            sprite: "sprite",
            timestamp: Date(),
            weight: 6.0,
            baseStats: nil,
            evolutions: nil,
            evYields: nil,
            gender: nil,
            preevolutions: nil,
            types: [PokemonTypeModel(name: "Electric")]
        )
        PokemonDetailView(pokemon: examplePokemon)
    }
}
