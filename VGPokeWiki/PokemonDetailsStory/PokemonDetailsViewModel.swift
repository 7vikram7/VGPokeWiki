//
//  PokemonDetailsViewModel.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation

//class SubtitleTableViewCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//struct HomeListItemViewModel {
//    static let pokeListTableViewReuseIdentifier = "pokeListTableViewReuseIdentifier"
//    var pokemonName = ""
//    var pokemonId = ""
//}

class PokemonDetailsViewModel: NSObject {

    // MARK: Public Properties
    var imageURL: URL?
    var weight: Int?
    var abilities: [String]?
    var types: [String]?

    init(pokemonDetailsResponseData: PokemonDetailsResponseData) {
        super.init()
        self.imageURL = URL(string: "\(Constants.pokemonFullImageURL)\(pokemonDetailsResponseData.id ?? 0).png")
        self.weight = pokemonDetailsResponseData.weight
        self.abilities = pokemonDetailsResponseData.abilities?.map{ $0.ability?.name ?? ""}
        self.types = pokemonDetailsResponseData.types?.map{ $0.type?.name  ?? ""}
    }
}
