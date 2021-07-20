//
//  Constants.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation

struct Constants {
    static let baseURL = "https://pokeapi.co/api/v2"
    static let pokemonListURL = baseURL + "/pokemon/?offset=0&limit=10"
    static let pokemonDetailsURL = baseURL + "/pokemon/"

    static let pokemonThumbImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    static let pokemonFullImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
}

