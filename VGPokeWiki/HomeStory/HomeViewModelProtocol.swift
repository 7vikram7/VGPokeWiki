//
//  HomeViewModelProtocol.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol: UITableViewDelegate, UITableViewDataSource {
    var sortingSelection: HomeSortingSelection { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var pokemonList: [HomeListItemViewModel] { get set }

    var stateUpdated: ()->() { get set }
    var showAlert: (HomeViewAlerts)->() { get set }

    func clearButtonEvent()
    func sortAlphabeticallyEvent()
    func sortNumericallyEvent()
}