//
//  CacheService.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/20/21.
//

import Foundation

class CacheService {
    func getPokemonDetailsfromCacheifPresent(pokemonName: String) -> PokemonDetailsViewModel? {
        return try? UserDefaults.standard.getObject(forKey: pokemonName, castTo: PokemonDetailsViewModel.self)
    }

    func savePokemonDetailInCache(pokemonDetailsViewModel: PokemonDetailsViewModel) {
        if let name = pokemonDetailsViewModel.name {
            try? UserDefaults.standard.setObject(pokemonDetailsViewModel, forKey: name)
        }
    }
}
