//
//  InputMealInformationViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class InputMealInformationViewCell: BaseTableViewCell, CellFrameTrackkable {
    @IBOutlet weak var calorieTitleLabel: UILabel! {
        didSet { calorieTitleLabel.text = R.string.localizable.energy() }
    }

    @IBOutlet weak var multipleTitleLabel: UILabel! {
        didSet { multipleTitleLabel.text = R.string.localizable.multiple() }
    }

    @IBOutlet weak var nameTitleLabel: UILabel! {
        didSet { nameTitleLabel.text = R.string.localizable.name() }
    }

    @IBOutlet weak var calorieTextField: RoundedTextField! {
        didSet {
            calorieTextField.keyboardType = .decimalPad
        }
    }

    @IBOutlet weak var multipleTextField: RoundedTextField! {
        didSet {
            multipleTextField.keyboardType = .decimalPad
        }
    }

    @IBOutlet weak var nameTextField: RoundedTextField!

    @IBOutlet weak var deleteMealButton: UIButton! {
        didSet { deleteMealButton.setTitle("🗑 " + R.string.localizable.delete(), for: .normal) }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextField.text = nil
        calorieTextField.text = nil
        multipleTextField.text = nil
    }

    func configure(input: KeyboardTrackViewModelInput, output: KeyboardTrackViewModelOutput) {
        [nameTextField,
         calorieTextField,
         multipleTextField].forEach {
            configure(textField: $0!, input: input, output: output)
        }
    }

    func configureTextField(input: InputMealViewModelInput, output: InputMealViewModelOutput) {
        calorieTextField.rx.text
            .bind(to: input.calorieTextInput)
            .disposed(by: disposeBag)

        multipleTextField.rx.text
            .bind(to: input.multipleTextInput)
            .disposed(by: disposeBag)

        nameTextField.rx.text
            .bind(to: input.nameTextInput)
            .disposed(by: disposeBag)

        deleteMealButton.rx.tap
            .subscribe(onNext: {
                input.contentWillDelete.on(.next(()))
                Haptic.notification(.success).generate()
            })
            .disposed(by: disposeBag)

        output.updateTextFields
            .bind(to: updateTextFields)
            .disposed(by: disposeBag)
    }

    var updateTextFields: Binder<Content> {
        Binder(self) { me, content in
            me.nameTextField.text = content.name
            me.calorieTextField.text = ""
            me.multipleTextField.text = ""
            let calorie = UnitBabel.shared.convert(value: content.calorie,
                                                   from: .kilocalories,
                                                   to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
            me.calorieTextField.placeholder = "\(calorie)"
            me.multipleTextField.placeholder = "\(content.multiple)"
        }
    }
}
