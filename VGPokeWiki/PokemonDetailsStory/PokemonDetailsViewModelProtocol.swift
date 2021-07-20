//
//  PokemonDetailsViewModelProtocol.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation
import UIKit

protocol PokemonDetailsViewModelProtocol: UITableViewDelegate, UITableViewDataSource {
    var imageURL: URL? { get set }
    var weight: Int? { get set }
    var name: String? { get set}
    var abilities: [String]? { get set }
    var types: [String]? { get set }
}
