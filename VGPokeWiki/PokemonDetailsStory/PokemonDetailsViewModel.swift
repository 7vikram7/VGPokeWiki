//
//  PokemonDetailsViewModel.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation
import UIKit

struct PokemonDetailsListItemViewModel {
    static let pokemonDetailsLisReuseIdentifier = "pokemonDetailsLisReuseIdentifier"
    var title = ""
    var details = ""
}

class PokemonDetailsViewModel: NSObject, PokemonDetailsViewModelProtocol, Codable {

    // MARK: Public Properties
    var imageURL: String?
    var weight: String?
    var name: String?
    var abilities: [String]?
    var types: [String]?

    // MARK: Initialization
    init(pokemonDetailsResponseData: PokemonDetailsResponseData) {
        super.init()
        self.imageURL = "\(Constants.pokemonFullImageURL)\(pokemonDetailsResponseData.id ?? 0).png"
        self.weight = "\(pokemonDetailsResponseData.weight ?? 0)"
        self.name = pokemonDetailsResponseData.name
        self.abilities = pokemonDetailsResponseData.abilities?.map{ $0.ability?.name ?? ""}
        self.types = pokemonDetailsResponseData.types?.map{ $0.type?.name  ?? ""}
    }

    // MARK: Public Methods
    func createPokemonDetailsViewController()-> PokemonDetailsViewController {
        let pokemonDetailsVC = PokemonDetailsViewController()
        pokemonDetailsVC.viewModel = self
        return pokemonDetailsVC
    }

    // MARK: Private Methods
    // MARK: Events
}

// MARK: Extensions
extension PokemonDetailsViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonDetailsListItemViewModel.pokemonDetailsLisReuseIdentifier, for: indexPath)
        return configureCellForRow(row: indexPath.row, cell: cell)
    }

    // MARK: Private Methods
    private func configureCellForRow(row: Int, cell: UITableViewCell) -> UITableViewCell {
        var titleText: String?
        var detailsText: String?

        switch row {
        case 0:
            titleText = NSLocalizedString("PokemonDetails_ListItem_Weight", comment: "")
            detailsText = "\(weight ?? "") \(NSLocalizedString("PokemonDetails_ListItem_WeightUnit", comment: ""))"
        case 1:
            titleText = NSLocalizedString("PokemonDetails_ListItem_Abilities", comment: "")
            detailsText = abilities?.map{$0.capitalized}.joined(separator: ", ")

        default:
            titleText = NSLocalizedString("PokemonDetails_ListItem_Type", comment: "")
            detailsText = types?.map{$0.capitalized}.joined(separator: ", ")
        }

        cell.textLabel?.text = titleText
        cell.detailTextLabel?.text = detailsText
        
        return cell
    }
}
