//
//  APIService.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/15/21.
//

import Foundation

class APIService :  NSObject {

    func getPokemonList(nextUrl: String, completion : @escaping (PokemonListResponseData?, Error?) -> ()){

        if let uRL = URL(string: nextUrl.isEmpty ? Constants.pokemonListURL : nextUrl) {
            URLSession.shared.dataTask(with: uRL) { (data, urlResponse, error) in
                if let data = data {

                    let jsonDecoder = JSONDecoder()

                    if let pokemonListResponseData = try? jsonDecoder.decode(PokemonListResponseData.self, from: data)
                    {
                        completion(pokemonListResponseData, error)
                    } else {
                        completion(nil, NSError(domain: "", code:0, userInfo: nil))
                    }
                }
            }.resume()
        } else {
            completion(nil, NSError(domain: "", code:0, userInfo: nil))
        }
    }

    func getPokemonDetails(searchString: String, completion : @escaping (PokemonDetailsResponseData?, Error?) -> ()){

        if let uRL = URL(string: Constants.pokemonDetailsURL + searchString) {
            URLSession.shared.dataTask(with: uRL) { (data, urlResponse, error) in
                if let data = data {

                    let jsonDecoder = JSONDecoder()

                    if let pokemonDetailsResponseData = try? jsonDecoder.decode(PokemonDetailsResponseData.self, from: data) {
                        completion(pokemonDetailsResponseData, error)
                    } else {
                        completion(nil, NSError(domain: "", code:0, userInfo: nil))
                    }
                }
            }.resume()
        } else {
            completion(nil, NSError(domain: "", code:0, userInfo: nil))
        }
    }

}
