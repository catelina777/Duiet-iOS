//
//  SelectElementViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/16.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SelectElementViewCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var leftButton: UIButton! {
        didSet {
            leftButton.makeRoundCornersAndColorEdges()
        }
    }

    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.makeRoundCornersAndColorEdges()
        }
    }

    var switchSelectedButton: Binder<Int> {
        Binder(self) { me, row in
            if row == 0 {
                me.leftButton.layer.borderColor = R.color.componentMain()!.cgColor
                me.rightButton.layer.borderColor = UIColor.clear.cgColor
            } else {
                me.leftButton.layer.borderColor = UIColor.clear.cgColor
                me.rightButton.layer.borderColor = R.color.componentMain()!.cgColor
            }
        }
    }

    func configure(with cellType: SelectUnitCellType,
                   isSelectedLeft: AnyObserver<Int?>) {
        titleLabel.text = cellType.title
        leftButton.setTitle(cellType.pairedUniTypes.0.unit.symbol, for: .normal)
        rightButton.setTitle(cellType.pairedUniTypes.1.unit.symbol, for: .normal)
        let didSelectLeft = PublishRelay<Int?>()
        leftButton.rx.tap
            .map { 0 }
            .bind(to: isSelectedLeft,
                  didSelectLeft.asObserver())
            .disposed(by: disposeBag)

        rightButton.rx.tap
            .map { 1 }
            .bind(to: isSelectedLeft,
                  didSelectLeft.asObserver())
            .disposed(by: disposeBag)

        didSelectLeft
            .compactMap { $0 }
            .bind(to: switchSelectedButton)
            .disposed(by: disposeBag)
    }
}
