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
            leftButton.makeEdges(cornerRadius: 10, borderWidth: 4)
        }
    }

    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.makeEdges(cornerRadius: 10, borderWidth: 4)
        }
    }

    var switchSelectedButton: Binder<Int16> {
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

    func configure(cellType: SelectUnitCellType,
                   isSelectedLeft: AnyObserver<Int16?>) {
        titleLabel.text = cellType.title
        leftButton.setTitle(cellType.pairedUniTypes.0.symbol, for: .normal)
        rightButton.setTitle(cellType.pairedUniTypes.1.symbol, for: .normal)
        let didSelectLeft = PublishRelay<Int16?>()
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
