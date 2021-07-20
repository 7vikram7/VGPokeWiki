//
//  PokemonDetailsListCell.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/20/21.
//

import Foundation
import UIKit

class PokemonDetailsListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
