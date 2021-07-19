//
//  HomeViewModel.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/16/21.
//

import Foundation
import UIKit

struct HomeListItemViewModel {
    static let pokeListTableViewReuseIdentifier = "pokeListTableViewReuseIdentifier"
    var pokemonName = ""
    var pokemonId = ""
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    // MARK: Public Properties
    var sortingSelection = HomeSortingSelection.noSelection
    var isLoading = false
    var searchText = ""
    var pokemonList = [HomeListItemViewModel]()

    // MARK: Private Properties
    var stateUpdated: ()->() = {}
    var showAlert: (HomeViewAlerts)->() = {_ in }

    private let maximumPokemonInList = 300
    private var apiService = APIService()
    private var nextUrl = ""
    private var pokemonDataList = [PokemonData]() {
        didSet {
            pokemonList = pokemonDataList.map{
                HomeListItemViewModel(pokemonName: $0.name ?? "",
                                      pokemonId: $0.url?.components(separatedBy: "/")[6] ?? "") }
        }
    }

    // MARK: Initialization
    override init() {
        super.init()
        getPokemonDetails(apiService: apiService)
    }

    // MARK: Public Methods
    static func createHomeViewController()-> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.viewModel = HomeViewModel()
        return homeVC
    }

    // MARK: Private Methods
    private func getPokemonDetails(apiService: APIService) {

        isLoading = true
        self.stateUpdated()

        apiService.getPokemonList(nextUrl: nextUrl, completion: { [weak self] (responsePokemonListResponseData, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if error == nil {
                    self?.nextUrl = responsePokemonListResponseData.next ?? ""
                    self?.pokemonDataList.append(contentsOf: responsePokemonListResponseData.results ?? [])
                } else {
                    self?.showAlert(HomeViewAlerts.getPokemonListFailed)
                }
                self?.stateUpdated()
            }
        })
    }

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

    // MARK: Events
    func clearButtonEvent() {
        sortingSelection = .noSelection
        stateUpdated()
    }

    func sortAlphabeticallyEvent() {
        switch sortingSelection {
        case .noSelection, .ascending, .descending, .alphabeticallyDescending:
            sortingSelection = .alphabeticallyAscending
        case .alphabeticallyAscending:
            sortingSelection = .alphabeticallyDescending
        }
        stateUpdated()
    }

    func sortNumericallyEvent() {
        switch sortingSelection {
        case .noSelection, .alphabeticallyAscending, .alphabeticallyDescending, .descending:
            sortingSelection = .ascending
        case .ascending:
            sortingSelection = .descending
        }
        stateUpdated()
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
        cell.textLabel?.text = currentViewModel.pokemonName.capitalized
        cell.detailTextLabel?.text = NSLocalizedString("Home_ListItem_SubTitlePrefix", comment: "") + (currentViewModel.pokemonId)

        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            if pokemonDataList.count < maximumPokemonInList {
                getPokemonDetails(apiService: apiService)
            } else {
                showAlert(HomeViewAlerts.maximumPokemonsFetched)
            }
        }
    }
}
