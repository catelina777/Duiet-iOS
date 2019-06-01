//
//  InputMealCalorieViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

class InputMealCalorieViewCell: RxTableViewCell, CellFrameTrackkable {

    @IBOutlet weak var mealNameTextField: MyTextField! {
        didSet {
            mealNameTextField.font = R.font.montserratExtraBold(size: 24)
            mealNameTextField.layer.cornerRadius = 10
            mealNameTextField.layer.masksToBounds = true
            mealNameTextField.placeholder = "option"
        }
    }

    @IBOutlet weak var mealCalorieTextField: MyTextField! {
        didSet {
            mealCalorieTextField.font = R.font.montserratExtraBold(size: 24)
            mealCalorieTextField.layer.cornerRadius = 10
            mealCalorieTextField.layer.masksToBounds = true
            mealCalorieTextField.keyboardType = .decimalPad
        }
    }

    @IBOutlet weak var mealAmountTextField: MyTextField! {
        didSet {
            mealAmountTextField.font = R.font.montserratExtraBold(size: 24)
            mealAmountTextField.layer.cornerRadius = 10
            mealAmountTextField.layer.masksToBounds = true
            mealAmountTextField.keyboardType = .decimalPad
            mealAmountTextField.placeholder = "option"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mealNameTextField.text = nil
        mealCalorieTextField.text = nil
        mealAmountTextField.text = nil
    }

    func configure(with viewModel: KeyboardTrackViewModel) {
        guard
            let appDelegate = UIApplication.shared.delegate,
            let optionalWindow = appDelegate.window,
            let window = optionalWindow
        else { return }

        let myTextFields = [mealNameTextField,
                            mealCalorieTextField,
                            mealAmountTextField]

        myTextFields.forEach { textField in
            guard let textField = textField else { return }
            configure(for: textField,
                      viewModel: viewModel,
                      window: window)
        }
    }

    func configure(with viewModel: InputMealViewModel) {
        mealCalorieTextField.rx.text
            .bind(to: viewModel.input.calorieTextInput)
            .disposed(by: disposeBag)

        mealAmountTextField.rx.text
            .bind(to: viewModel.input.multipleTextInput)
            .disposed(by: disposeBag)

        mealNameTextField.rx.text
            .bind(to: viewModel.input.nameTextInput)
            .disposed(by: disposeBag)

        viewModel.output.selectedMealLabel
            .bind(to: updateTextField)
            .disposed(by: disposeBag)
    }

    var updateTextField: Binder<MealLabelView> {
        return Binder(self) { me, mealLabel in
            let content = mealLabel.content.value
            me.mealCalorieTextField.text = "\(Int(content.calorie))"
            me.mealAmountTextField.text = "\(Int(content.multiple))"
            me.mealNameTextField.text = content.name
        }
    }
}
