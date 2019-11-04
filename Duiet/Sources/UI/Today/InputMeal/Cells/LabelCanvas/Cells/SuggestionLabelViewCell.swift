//
//  SuggestionLabelViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class SuggestionLabelViewCell: UICollectionViewCell {
    @IBOutlet private weak var suggestionName: UILabel!

    func configure(with content: Content) {
        suggestionName.text = content.name
        contentView.makeEdges(cornerRadius: 15, borderWidth: 1)
        contentView.layer.borderColor = R.color.componentMain()?.cgColor
    }
}
