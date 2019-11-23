//
//  ExplainCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class ExplainCardViewCell: BaseCollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!

    func configure(type: ManageDataType) {
        titleLabel.text = type.title
        descriptionTextView.text = type.description
    }
}
