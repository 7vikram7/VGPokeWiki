//
//  ViewExtension.swift
//  VGPokeWiki
//
//  Created by Vicky's Red Devil on 7/14/21.
//

import UIKit

extension UIView {
    func addSubViewForAutolayout(_ childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(childView)
    }
}
