//
//  ViewController.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/13/21.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: Public Properties
    var viewModel : HomeViewModelProtocol!

    // MARK: Private Properties
    private weak var searchBar: UISearchBar!
    private weak var sortView: UIView!
    private weak var clearButton: UIButton!
    private weak var alphabeticalSortButton: UIButton!
    private weak var numericSortButton: UIButton!
    private weak var pokeListTableView: UITableView!
    private weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("ViewModel not assigned for Home View")
        }
        self.title = "VGPokeWiki"
        setupEventCallbacks()
        createSubViews()
        setupConstraints()
        setupStyles()
        updateViewContent()
    }
    
    // MARK: Public Methods
    // MARK: Private Methods

    private func updateViewContent() {

        searchBar.text = viewModel.searchText

        viewModel.isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        view.isUserInteractionEnabled = !viewModel.isLoading

        clearButton.isHidden = viewModel.sortingSelection == .noSelection

        var alphabeticalImage: UIImage?
        var numericImage: UIImage?
        switch viewModel.sortingSelection {
        case .noSelection:
            alphabeticalImage = nil
            numericImage = nil
        case .alphabeticallyAscending:
            alphabeticalImage = UIImage(systemName: "chevron.up",
                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            numericImage = nil
        case .alphabeticallyDescending:
            alphabeticalImage = UIImage(systemName: "chevron.down",
                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            numericImage = nil
        case .ascending:
            alphabeticalImage = nil
            numericImage = UIImage(systemName: "chevron.up",
                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        case .descending:
            alphabeticalImage = nil
            numericImage = UIImage(systemName: "chevron.down",
                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        }
        alphabeticalSortButton.setImage(alphabeticalImage, for: .normal)
        numericSortButton.setImage(numericImage, for: .normal)

        pokeListTableView.reloadData()

    }

    private func displayAlert(alertType: HomeViewAlerts) {
        var title, message, actionTitle: String?

        switch alertType {
        case .maximumPokemonsFetched:
            title = NSLocalizedString("Alert", comment: "")
            message = NSLocalizedString("Home_Alert_MaximumPokemonsFetched", comment: "")
        case .getPokemonListFailed:
            title = NSLocalizedString("Oops", comment: "")
            message = NSLocalizedString("Home_Alert_GetPokemonListFailed", comment: "")
        case .getPokemonDetailsFailedForTapOnList:
            title = NSLocalizedString("Oops", comment: "")
            message = NSLocalizedString("Home_Alert_GetPokemonDetailsFailedOnTapOfList", comment: "")
        case .getPokemonDetailsFailedForSearch:
            title = NSLocalizedString("Alert", comment: "")
            message = NSLocalizedString("Home_Alert_GetPokemonDetailsFailedOnSearch", comment: "")
        case .emptyPokemonSearch:
            message = NSLocalizedString("Home_Alert_EmptyPokemonSearch", comment: "")
        }

        actionTitle = NSLocalizedString("Ok", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: Events
    private func setupEventCallbacks() {
        viewModel.stateUpdated = { [weak self] in
            self?.updateViewContent()
        }

        viewModel.showAlert = { [weak self] (homeAlert) in
            self?.displayAlert(alertType: homeAlert)
        }

        viewModel.navigateToController = { [weak self] (viewController) in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @objc private func clearButtonTapped() {
        pokeListTableView.setContentOffset(.zero, animated: false)
        viewModel.clearButtonEvent()
    }

    @objc private func sortAlphabeticallyTapped() {
        pokeListTableView.setContentOffset(.zero, animated: false)
        viewModel.sortAlphabeticallyEvent()
    }

    @objc private func sortNumericallyTapped() {
        pokeListTableView.setContentOffset(.zero, animated: false)
        viewModel.sortNumericallyEvent()
    }
}

// MARK: Extensions

extension HomeViewController {
    // MARK: UI Creation

    private func createSubViews() {
        createSearchBar()
        createSortView()
        createSortButtons()
        createPokeListTableView()
        createLoadingIndicator()
    }

    private func createSearchBar() {
        let searchBar = UISearchBar()
        view.addSubViewForAutolayout(searchBar)
        searchBar.showsCancelButton = true
        searchBar.searchTextField.delegate = viewModel
        searchBar.delegate = viewModel
        self.searchBar = searchBar
    }

    private func createSortView() {
        let sortView = UIStackView()
        view.addSubViewForAutolayout(sortView)
        self.sortView = sortView
    }

    private func createSortButtons() {
        let clearButton = UIButton()
        sortView.addSubViewForAutolayout(clearButton)
        clearButton.addTarget(self, action: #selector(HomeViewController.clearButtonTapped), for: .touchUpInside)
        self.clearButton = clearButton

        let alphabeticalSortButton = UIButton()
        sortView.addSubViewForAutolayout(alphabeticalSortButton)
        alphabeticalSortButton.addTarget(self, action: #selector(HomeViewController.sortAlphabeticallyTapped), for: .touchUpInside)
        self.alphabeticalSortButton = alphabeticalSortButton

        let numericSortButton = UIButton()
        sortView.addSubViewForAutolayout(numericSortButton)
        numericSortButton.addTarget(self, action: #selector(HomeViewController.sortNumericallyTapped), for: .touchUpInside)
        self.numericSortButton = numericSortButton
    }

    private func createPokeListTableView() {
        let pokeListTableView = UITableView()
        view.addSubViewForAutolayout(pokeListTableView)
        pokeListTableView.register(HomeListItemCell.self, forCellReuseIdentifier: HomeListItemViewModel.pokeListTableViewReuseIdentifier)
        pokeListTableView.dataSource = viewModel
        pokeListTableView.delegate = viewModel
        self.pokeListTableView = pokeListTableView
    }

    private func createLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView()
        view.addSubViewForAutolayout(loadingIndicator)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        self.loadingIndicator = loadingIndicator
    }

    private func setupConstraints() {
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
                                     alphabeticalSortButton.widthAnchor.constraint(equalToConstant: 80.0)])

        NSLayoutConstraint.activate([numericSortButton.leadingAnchor.constraint(equalTo: alphabeticalSortButton.trailingAnchor, constant: 10.0),
                                     numericSortButton.trailingAnchor.constraint(equalTo: sortView.trailingAnchor, constant: -10.0),
                                     numericSortButton.topAnchor.constraint(equalTo: sortView.topAnchor, constant: 10.0),
                                     numericSortButton.bottomAnchor.constraint(equalTo: sortView.bottomAnchor, constant: -10.0),
                                     numericSortButton.widthAnchor.constraint(equalToConstant: 80.0)])

        NSLayoutConstraint.activate([pokeListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     pokeListTableView.topAnchor.constraint(equalTo: sortView.bottomAnchor),
                                     pokeListTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     pokeListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])

        NSLayoutConstraint.activate([loadingIndicator.widthAnchor.constraint(equalToConstant: 50.0),
                                     loadingIndicator.heightAnchor.constraint(equalToConstant: 50.0),
                                     loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])

    }

    private func setupStyles() {

        //TODO: refactor with primary and secondary colors keeping in mind dark mode
        searchBar.placeholder = NSLocalizedString("Home_SearchBar_Title", comment: "")
        searchBar.autocapitalizationType = .none
        searchBar.tintColor = .darkGray
        searchBar.backgroundColor = .darkGray
        searchBar.sizeToFit()

        sortView.backgroundColor = .darkGray

        clearButton.setTitle(NSLocalizedString("Home_ClearSort_Title", comment: ""), for: .normal)
        clearButton.backgroundColor = .clear
        clearButton.layer.cornerRadius = 5
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.white.cgColor

        alphabeticalSortButton.setTitle("Aa", for: .normal)
        alphabeticalSortButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        alphabeticalSortButton.backgroundColor = .clear
        alphabeticalSortButton.layer.cornerRadius = 5
        alphabeticalSortButton.layer.borderWidth = 1
        alphabeticalSortButton.layer.borderColor = UIColor.white.cgColor

        numericSortButton.setTitle("1-9", for: .normal)
        numericSortButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        numericSortButton.backgroundColor = .clear
        numericSortButton.layer.cornerRadius = 5
        numericSortButton.layer.borderWidth = 1
        numericSortButton.layer.borderColor = UIColor.white.cgColor

        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.layer.cornerRadius = 5.0
        loadingIndicator.alpha = 0.85
        loadingIndicator.color = .white
        loadingIndicator.backgroundColor = .darkGray

    }
}
