//
//  PokemonDetailsResponseData.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation

struct Type: Decodable {
    var name, url: String?
}

struct TypeDetails: Decodable {
    var type: Type?
}

struct Ability: Decodable {
    var name, url: String?
}

struct AbilityDetails: Decodable {
    var ability: Ability?
}

struct PokemonDetailsResponseData: Decodable {
    var weight: Int?
    var id: Int?
    var abilities: [AbilityDetails]?
    var types: [TypeDetails]?
}


