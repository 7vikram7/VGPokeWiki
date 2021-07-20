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

                    let pokemonListResponseData = try! jsonDecoder.decode(PokemonListResponseData.self, from: data)
                    completion(pokemonListResponseData, error)
                }
            }.resume()
        } else {
            let error = NSError(domain: "", code:0, userInfo: nil)
            completion(nil, error)
        }
    }

    func getPokemonDetails(searchString: String, completion : @escaping (PokemonDetailsResponseData?, Error?) -> ()){

        if let uRL = URL(string: Constants.pokemonDetailsURL + searchString) {
            URLSession.shared.dataTask(with: uRL) { (data, urlResponse, error) in
                if let data = data {

                    let jsonDecoder = JSONDecoder()

                    let pokemonDetailsResponseData = try! jsonDecoder.decode(PokemonDetailsResponseData.self, from: data)
                    completion(pokemonDetailsResponseData, error)
                }
            }.resume()
        } else {
            let error = NSError(domain: "", code:0, userInfo: nil)
            completion(nil, error)
        }
    }

}
