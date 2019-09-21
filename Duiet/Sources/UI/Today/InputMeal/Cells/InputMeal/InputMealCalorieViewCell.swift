//
//  InputMealCalorieViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class InputMealCalorieViewCell: BaseTableViewCell, CellFrameTrackkable {
    @IBOutlet weak var calorieTitleLabel: UILabel! {
        didSet { calorieTitleLabel.text = R.string.localizable.calorie() }
    }

    @IBOutlet weak var multipleTitleLabel: UILabel! {
        didSet { multipleTitleLabel.text = R.string.localizable.multiple() }
    }

    @IBOutlet weak var nameTitleLabel: UILabel! {
        didSet { nameTitleLabel.text = R.string.localizable.name() }
    }

    @IBOutlet weak var calorieTextField: MyTextField! {
        didSet {
            calorieTextField.font = R.font.montserratExtraBold(size: 24)
            calorieTextField.layer.cornerRadius = 10
            calorieTextField.layer.masksToBounds = true
            calorieTextField.keyboardType = .decimalPad
        }
    }

    @IBOutlet weak var multipleTextField: MyTextField! {
        didSet {
            multipleTextField.font = R.font.montserratExtraBold(size: 24)
            multipleTextField.layer.cornerRadius = 10
            multipleTextField.layer.masksToBounds = true
            multipleTextField.keyboardType = .decimalPad
        }
    }

    @IBOutlet weak var nameTextField: MyTextField! {
        didSet {
            nameTextField.font = R.font.montserratExtraBold(size: 24)
            nameTextField.layer.cornerRadius = 10
            nameTextField.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var deleteMealButton: UIButton! {
        didSet { deleteMealButton.setTitle("🗑 " + R.string.localizable.delete(), for: .normal) }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextField.text = nil
        calorieTextField.text = nil
        multipleTextField.text = nil
    }

    func configure(with viewModel: KeyboardTrackViewModel) {
        guard
            let appDelegate = UIApplication.shared.delegate,
            let optionalWindow = appDelegate.window,
            let window = optionalWindow
        else { return }

        [nameTextField,
         calorieTextField,
         multipleTextField].forEach {
            guard let textField = $0 else { return }
            configure(for: textField,
                      viewModel: viewModel,
                      window: window)
        }
    }

    func configure(with viewModel: InputMealViewModelProtocol) {
        calorieTextField.rx.text
            .bind(to: viewModel.input.calorieTextInput)
            .disposed(by: disposeBag)

        multipleTextField.rx.text
            .bind(to: viewModel.input.multipleTextInput)
            .disposed(by: disposeBag)

        nameTextField.rx.text
            .bind(to: viewModel.input.nameTextInput)
            .disposed(by: disposeBag)

        deleteMealButton.rx.tap
            .bind(to: viewModel.input.contentWillDelete)
            .disposed(by: disposeBag)

        viewModel.output.updateTextFields
            .bind(to: updateTextFields)
            .disposed(by: disposeBag)
    }

    var updateTextFields: Binder<Content> {
        return Binder(self) { me, content in
            me.nameTextField.text = content.name
            me.calorieTextField.text = ""
            me.multipleTextField.text = ""
            me.calorieTextField.placeholder = "\(content.calorie)"
            me.multipleTextField.placeholder = "\(content.multiple)"
        }
    }
}
