//
//  PokemonDetailsViewController.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/14/21.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    // MARK: Public Properties
    var viewModel : PokemonDetailsViewModelProtocol!

    // MARK: Private Properties
    private weak var pokemonImageView: LoaderImageView!
    private weak var pokemonDetailsTableView: UITableView!

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        if viewModel == nil {
            fatalError("ViewModel not assigned for Home View")
        }
        createSubViews()
        setupConstraints()
        setupStyles()
        updateViewContent()
    }

    // MARK: Public Methods
    // MARK: Private Methods

    private func updateViewContent() {

        self.title = viewModel.name?.capitalized

        if let urlString = viewModel.imageURL, let url = URL(string:urlString) {
            pokemonImageView.loadImageWithUrl(url)
        }
        pokemonDetailsTableView.reloadData()

    }

    // MARK: Events
}

// MARK: Extensions

extension PokemonDetailsViewController {
    // MARK: UI Creation

    private func createSubViews() {
        createpokemonImageView()
        createPokemonDetailsTableView()
    }

    private func createpokemonImageView() {
        let pokemonImageView = LoaderImageView()
        view.addSubViewForAutolayout(pokemonImageView)
        pokemonImageView.contentMode = .scaleAspectFill
        self.pokemonImageView = pokemonImageView
    }

    private func createPokemonDetailsTableView() {
        let pokemonDetailsTableView = UITableView()
        view.addSubViewForAutolayout(pokemonDetailsTableView)
        pokemonDetailsTableView.register(PokemonDetailsListCell.self, forCellReuseIdentifier: PokemonDetailsListItemViewModel.pokemonDetailsLisReuseIdentifier)
        pokemonDetailsTableView.dataSource = viewModel
        pokemonDetailsTableView.delegate = viewModel
        self.pokemonDetailsTableView = pokemonDetailsTableView
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([pokemonImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     pokemonImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     pokemonImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)])

        NSLayoutConstraint.activate([pokemonDetailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     pokemonDetailsTableView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor),
                                     pokemonDetailsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     pokemonDetailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])

    }

    private func setupStyles() {

        //TODO: refactor with primary and secondary colors keeping in mind dark mode

        pokemonImageView.backgroundColor = .white

        pokemonDetailsTableView.bounces = false
        pokemonDetailsTableView.showsVerticalScrollIndicator = false

    }
}

