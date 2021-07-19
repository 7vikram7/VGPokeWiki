//
//  APIService.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/15/21.
//

import Foundation

struct Constants {
    static let baseURL = "https://pokeapi.co/api/v2"
    static let pokemonListURL = baseURL + "/pokemon/?offset=0&limit=10"
}

struct PokemonData: Decodable {
    var name, url: String?
}

struct PokemonListResponseData: Decodable {
    var next: String?
    var results: [PokemonData]?
}

class APIService :  NSObject {

    func getPokemonList(nextUrl: String, completion : @escaping (PokemonListResponseData, Error?) -> ()){

        let uRL = URL(string: nextUrl.isEmpty ? Constants.pokemonListURL : nextUrl)!
        URLSession.shared.dataTask(with: uRL) { (data, urlResponse, error) in
            if let data = data {

                let jsonDecoder = JSONDecoder()

                let pokemonListResponseData = try! jsonDecoder.decode(PokemonListResponseData.self, from: data)
                completion(pokemonListResponseData, error)
            }
        }.resume()
    }
}
