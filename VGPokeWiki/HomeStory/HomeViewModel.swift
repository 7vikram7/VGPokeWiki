//
//  HomeViewModel.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/16/21.
//

import Foundation
import UIKit

enum HomeSortingSelection{
    case noSelection
    case alphabeticallyAscending
    case alphabeticallyDescending
    case ascending
    case descending
}

struct HomeListItemViewModel {

    static let pokeListTableViewReuseIdentifier = "pokeListTableViewReuseIdentifier"


    var pokemonName = ""
    var pokemonId = ""
}

enum HomeViewAlerts {
    case getPokemonListFailed
}

class HomeViewModel: NSObject {
    // MARK: Properties
    var sortingSelection = HomeSortingSelection.noSelection {
        didSet {}
    }
    var isLoading = false
    var searchText = ""
    var pokemonList = [HomeListItemViewModel]()

    var stateUpdated: ()->() = {}
    var showAlert: (HomeViewAlerts)->() = {_ in }
    //TODO: Try better way

    @objc var clearButtonTapped = {}


    private var apiService : APIService!
    private var nextUrl = ""
    private var pokemonDataList = [PokemonData]()

    func callFuncToGetEmpData() {
        apiService.getPokemonList(nextUrl: nextUrl, completion: { [weak self] (responsePokemonListResponseData, error) in
            if error != nil {
                self?.nextUrl = responsePokemonListResponseData.next ?? ""
                self?.pokemonDataList.append(contentsOf: responsePokemonListResponseData.results ?? [])
            } else {
                self?.showAlert(HomeViewAlerts.getPokemonListFailed)
            }
        })
    }

    // MARK: Private Methods

    private func getSortedPokemonList(homeListItemViewModels:[HomeListItemViewModel], currentSortSelection: HomeSortingSelection) -> [HomeListItemViewModel] {
        switch currentSortSelection {
        case .noSelection:
            return homeListItemViewModels
        case .alphabeticallyAscending:
            return homeListItemViewModels.sorted{ $0.pokemonName < $1.pokemonName }
        case .alphabeticallyDescending:
            return homeListItemViewModels.sorted{ $0.pokemonName > $1.pokemonName }
        case .ascending:
            return homeListItemViewModels.sorted{ Int($0.pokemonId) ?? 0 < Int($1.pokemonId) ?? 0 }
        case .descending:
            return homeListItemViewModels.sorted{ Int($0.pokemonId) ?? 0 > Int($1.pokemonId) ?? 0}
        }
    }

}
// MARK: Extensions
extension HomeViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeListItemViewModel.pokeListTableViewReuseIdentifier, for: indexPath)

        if pokemonList.count <= indexPath.row {
            return UITableViewCell()
        }

        let currentViewModel = getSortedPokemonList(homeListItemViewModels: pokemonList, currentSortSelection: sortingSelection) [indexPath.row]
        cell.textLabel?.text = currentViewModel.pokemonName
        cell.detailTextLabel?.text = NSLocalizedString("Home_ListItem_SubTitlePrefix", comment: "") + (currentViewModel.pokemonId)

        return cell
    }

}
