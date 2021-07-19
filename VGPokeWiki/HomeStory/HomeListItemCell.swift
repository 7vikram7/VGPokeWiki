//
//  HomeListItemCell.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/19/21.
//

import Foundation
import UIKit

class HomeListItemCell: UITableViewCell {

    // MARK: Public Properties
    let pokemonImageView = LoaderImageView()
    let pokemonTitleLabel = UILabel()
    let pokemonIdLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubViewForAutolayout(pokemonImageView)
        pokemonImageView.backgroundColor = UIColor.clear
        pokemonImageView.contentMode = .scaleAspectFill

        contentView.addSubViewForAutolayout(pokemonTitleLabel)
        pokemonTitleLabel.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: UITraitCollection(legibilityWeight: .bold))

        contentView.addSubViewForAutolayout(pokemonIdLabel)
        pokemonIdLabel.font = UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: UITraitCollection(legibilityWeight: .regular))
        pokemonIdLabel.textColor = .gray

        NSLayoutConstraint.activate([pokemonImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
                                     pokemonImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
                                     pokemonImageView.widthAnchor.constraint(equalToConstant: 60.0),
                                     pokemonImageView.heightAnchor.constraint(equalToConstant: 60.0)])


        NSLayoutConstraint.activate([pokemonTitleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 84),
                                     pokemonTitleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
                                     pokemonTitleLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                                     pokemonTitleLabel.heightAnchor.constraint(equalToConstant: 28.0)])

        NSLayoutConstraint.activate([pokemonIdLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 84),
                                     pokemonIdLabel.topAnchor.constraint(equalTo: pokemonTitleLabel.bottomAnchor),
                                     pokemonIdLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
                                     pokemonIdLabel.heightAnchor.constraint(equalToConstant: 12.0),
                                     NSLayoutConstraint(item: pokemonIdLabel, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: contentView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -12.0)])

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

