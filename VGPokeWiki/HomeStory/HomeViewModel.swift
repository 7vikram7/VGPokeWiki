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

    var stateUpdated: ()->() = {}
    var showAlert: (HomeViewAlerts)->() = {_ in }
    var navigateToController: (UIViewController)->() = {_ in }

    // MARK: Private Properties
    private let maximumPokemonInList = 300
    private var apiService = APIService()
    private var cacheService = CacheService()
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
        getPokemonList(apiService: apiService)
    }

    // MARK: Public Methods
    static func createHomeViewController()-> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.viewModel = HomeViewModel()
        return homeVC
    }

    // MARK: Private Methods
    private func getPokemonList(apiService: APIService) {

        isLoading = true
        self.stateUpdated()

        apiService.getPokemonList(nextUrl: nextUrl, completion: { [weak self] (responsePokemonListResponseData, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if error == nil {
                    self?.nextUrl = responsePokemonListResponseData?.next ?? ""
                    self?.pokemonDataList.append(contentsOf: responsePokemonListResponseData?.results ?? [])
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

    private func getPokemonDetailsFromCache(cacheService: CacheService, searchString: String, isViaTap: Bool = true) {
        if let pokemonDetailsViewModel = cacheService.getPokemonDetailsfromCacheifPresent(pokemonName: searchString) {
            searchText = ""
            stateUpdated()
            self.navigateToPokemonDetails(pokemonDetailsViewModel:pokemonDetailsViewModel)
        } else {
            getPokemonDetails(apiService: apiService, cacheService: cacheService, searchString: searchString, isViaTap: isViaTap)
        }
    }

    private func getPokemonDetails(apiService: APIService, cacheService:CacheService, searchString: String, isViaTap: Bool = true) {

        isLoading = true
        self.stateUpdated()

        apiService.getPokemonDetails(searchString: searchString, completion: { [weak self] (pokemonDetailsResponseData, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let pokemonDetailsResponseData = pokemonDetailsResponseData, error == nil {
                    let pokemonDetailsViewModel = PokemonDetailsViewModel(pokemonDetailsResponseData: pokemonDetailsResponseData)
                    self?.searchText = ""
                    self?.cacheService.savePokemonDetailInCache(pokemonDetailsViewModel: pokemonDetailsViewModel)
                    self?.navigateToPokemonDetails(pokemonDetailsViewModel:pokemonDetailsViewModel)
                } else {
                    if isViaTap {
                        self?.showAlert(HomeViewAlerts.getPokemonDetailsFailedForTapOnList)
                    } else {
                        self?.showAlert(HomeViewAlerts.getPokemonDetailsFailedForSearch)
                    }
                }
                self?.stateUpdated()
            }
        })
    }

    private func navigateToPokemonDetails(pokemonDetailsViewModel: PokemonDetailsViewModel) {
        let pokemonDetailsViewController = PokemonDetailsViewController()
        pokemonDetailsViewController.viewModel = pokemonDetailsViewModel
        navigateToController(pokemonDetailsViewController)
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

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeListItemViewModel.pokeListTableViewReuseIdentifier, for: indexPath) as? HomeListItemCell

        if pokemonList.count <= indexPath.row {
            return UITableViewCell()
        }

        let currentViewModel = getSortedPokemonList(homeListItemViewModels: pokemonList, currentSortSelection: sortingSelection) [indexPath.row]
        cell?.pokemonTitleLabel.text = currentViewModel.pokemonName.capitalized
        cell?.pokemonIdLabel.text = NSLocalizedString("Home_ListItem_SubTitlePrefix", comment: "") + (currentViewModel.pokemonId)
        if let url = URL(string: Constants.pokemonThumbImageURL + "\(currentViewModel.pokemonId).png")
        {
            cell?.pokemonImageView.loadImageWithUrl(url)
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentViewModel = getSortedPokemonList(homeListItemViewModels: pokemonList, currentSortSelection: sortingSelection) [indexPath.row]
        getPokemonDetailsFromCache(cacheService: cacheService, searchString: currentViewModel.pokemonName)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            if pokemonDataList.count < maximumPokemonInList {
                getPokemonList(apiService: apiService)
            } else {
                showAlert(HomeViewAlerts.maximumPokemonsFetched)
            }
        }
    }
}

extension HomeViewModel: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let allowedCharacters = "0123456789abcdefghijklmnopqrstuvwxyz"
        let aSet = NSCharacterSet(charactersIn:allowedCharacters).inverted
        let compSepByCharInSet = text.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return text == numberFiltered
    }
}

extension HomeViewModel: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchText = textField.text {
            getPokemonDetailsFromCache(cacheService: cacheService, searchString: searchText, isViaTap: false)
        } else {
            showAlert(HomeViewAlerts.emptyPokemonSearch)
        }
        return true
    }
}
