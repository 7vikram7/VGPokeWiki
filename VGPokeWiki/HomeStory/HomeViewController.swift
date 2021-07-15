//
//  ViewController.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/13/21.
//

import UIKit

enum HomeSortingSelection{
    case noSelection
    case alphabeticallyAscending
    case alphabeticallyDescending
    case ascending
    case descending
}

struct HomeListItemViewModel {
    var pokemonName = ""
    var pokemonId = ""
}

class HomeViewModel {
    var sortingSelection = HomeSortingSelection.noSelection
    var isLoading = false
    var searchText = ""
    var pokemonList = [HomeListItemViewModel]()
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HomeViewController: UIViewController {

    // MARK: Properties
    var viewModel : HomeViewModel!

    private weak var searchBar: UISearchBar!
    private weak var sortView: UIView!
    private weak var clearButton: UIButton!
    private weak var alphabeticalSortButton: UIButton!
    private weak var numericSortButton: UIButton!
    private weak var pokeListTableView: UITableView!

    private let pokeListTableViewReuseIdentifier = "pokeListTableViewReuseIdentifier"

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()


        //TODO: remove this
        let viewModel = HomeViewModel()
        let pokemonList = [
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Charmander", pokemonId: "4"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Charmander", pokemonId: "4"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Charmander", pokemonId: "4"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Charmander", pokemonId: "4"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
            HomeListItemViewModel(pokemonName: "Bulbasaur", pokemonId: "1"),
        ]
        viewModel.pokemonList = pokemonList
        self.viewModel = viewModel

        createSubViews()
        setupConstraints()
    }

    // MARK: UI Creation

    private func createSubViews() {
        createSearchBar()
        createSortView()
        createSortButtons()
        createPokeListTableView()
    }

    private func createSearchBar() {
        let searchBar = UISearchBar()
        view.addSubViewForAutolayout(searchBar)
        searchBar.placeholder = NSLocalizedString("Home_SearchBar_Title", comment: "")
        // TODO: customize UI
        //        searchBar.sizeToFit()
        //        searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        //        searchBar.tintColor = self.view.tintColor
        //        searchBar.right
        self.searchBar = searchBar
    }

    private func createSortView() {
        let sortView = UIStackView()
        view.addSubViewForAutolayout(sortView)
        sortView.backgroundColor = .red
        self.sortView = sortView
    }

    private func createSortButtons() {
        let clearButton = UIButton()
        sortView.addSubViewForAutolayout(clearButton)
        clearButton.addTarget(self, action: #selector(HomeViewController.clearButtonTapped), for: .touchUpInside)
        clearButton.backgroundColor = .blue
        self.clearButton = clearButton

        let alphabeticalSortButton = UIButton()
        sortView.addSubViewForAutolayout(alphabeticalSortButton)
        clearButton.addTarget(self, action: #selector(HomeViewController.sortAlphabeticallyTapped), for: .touchUpInside)
        alphabeticalSortButton.backgroundColor = .blue
        self.alphabeticalSortButton = alphabeticalSortButton

        let numericSortButton = UIButton()
        sortView.addSubViewForAutolayout(numericSortButton)
        clearButton.addTarget(self, action: #selector(HomeViewController.sortNumericallyTapped), for: .touchUpInside)
        numericSortButton.backgroundColor = .blue
        self.numericSortButton = numericSortButton
    }

    private func createPokeListTableView() {
        let pokeListTableView = UITableView()
        view.addSubViewForAutolayout(pokeListTableView)
        pokeListTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: pokeListTableViewReuseIdentifier)
        pokeListTableView.dataSource = self
        pokeListTableView.delegate = self
        self.pokeListTableView = pokeListTableView
    }
    
    private func setupConstraints() {
        //        NSLayoutConstraint(
        NSLayoutConstraint.activate([searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     searchBar.heightAnchor.constraint(equalToConstant: 50.0)])

        NSLayoutConstraint.activate([sortView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     sortView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                                     sortView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     sortView.heightAnchor.constraint(equalToConstant: 60.0)])

        NSLayoutConstraint.activate([clearButton.leadingAnchor.constraint(equalTo: sortView.leadingAnchor, constant: 10.0),
                                     clearButton.topAnchor.constraint(equalTo: sortView.topAnchor, constant: 10.0),
                                     clearButton.bottomAnchor.constraint(equalTo: sortView.bottomAnchor, constant: -10.0),
        ])
        clearButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([alphabeticalSortButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 10.0),
                                     alphabeticalSortButton.topAnchor.constraint(equalTo: sortView.topAnchor, constant: 10.0),
                                     alphabeticalSortButton.bottomAnchor.constraint(equalTo: sortView.bottomAnchor, constant: -10.0),
                                     alphabeticalSortButton.widthAnchor.constraint(equalToConstant: 40.0)])

        NSLayoutConstraint.activate([numericSortButton.leadingAnchor.constraint(equalTo: alphabeticalSortButton.trailingAnchor, constant: 10.0),
                                     numericSortButton.trailingAnchor.constraint(equalTo: sortView.trailingAnchor, constant: -10.0),
                                     numericSortButton.topAnchor.constraint(equalTo: sortView.topAnchor, constant: 10.0),
                                     numericSortButton.bottomAnchor.constraint(equalTo: sortView.bottomAnchor, constant: -10.0),
                                     numericSortButton.widthAnchor.constraint(equalToConstant: 40.0)])

        NSLayoutConstraint.activate([pokeListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     pokeListTableView.topAnchor.constraint(equalTo: sortView.bottomAnchor),
                                     pokeListTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     pokeListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])

    }

    // MARK: Events

    @objc private func clearButtonTapped() {
        viewModel.sortingSelection = .noSelection
    }

    @objc private func sortAlphabeticallyTapped() {
        switch viewModel.sortingSelection {
        case .noSelection, .ascending, .descending, .alphabeticallyDescending:
            viewModel.sortingSelection = .alphabeticallyAscending
        case .alphabeticallyAscending:
            viewModel.sortingSelection = .alphabeticallyDescending
        }
    }

    @objc private func sortNumericallyTapped() {
        switch viewModel.sortingSelection {
        case .noSelection, .alphabeticallyAscending, .alphabeticallyDescending, .descending:
            viewModel.sortingSelection = .ascending
        case .ascending:
            viewModel.sortingSelection = .descending
        }

    }

    // MARK: Public Methods
    // MARK: Private Methods
}

// MARK: Extensions
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pokeListTableViewReuseIdentifier, for: indexPath)

        if viewModel.pokemonList.count <= indexPath.row {
            return UITableViewCell()
        }

        let currentViewModel = viewModel.pokemonList[indexPath.row]
        cell.textLabel?.text = currentViewModel.pokemonName
        cell.detailTextLabel?.text = NSLocalizedString("Home_ListItem_SubTitlePrefix", comment: "") + (currentViewModel.pokemonId)

        return cell
    }

}
