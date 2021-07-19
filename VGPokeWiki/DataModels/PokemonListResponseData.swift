//
//  PokemonListResponseData.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation

struct PokemonListResponseData: Decodable {
    var next: String?
    var results: [PokemonData]?
}

