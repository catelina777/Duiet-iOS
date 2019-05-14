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

class InputMealCalorieViewCell: RxTableViewCell {

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

    func configure(with viewModel: InputMealViewModel, tableView: UITableView) {
        guard
            let appdelegate = UIApplication.shared.delegate,
            let window = appdelegate.window
        else { return }

        let myTextFields = [mealNameTextField, mealCalorieTextField, mealAmountTextField]
        myTextFields.forEach { textField in
            guard let textField = textField else { return }
            textField.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: { _ in
                    let frame = textField.convert(textField.frame, to: window)
                    viewModel.input.inputFieldFrame.on(.next(frame))
                })
                .disposed(by: disposeBag)

            // Detect the keyboard layout change being edited and get the current value of the input form layout.
            // If you do not do this, the old input form layout is referenced and scrolling does not work properly.
            viewModel.output.keyboardWillShow
                .filter { _ in textField.isEditing }
                .map { _ in }
                .subscribe(onNext: {
                    let frame = textField.convert(textField.frame, to: window)
                    viewModel.input.inputFieldFrame.on(.next(frame))
                })
                .disposed(by: disposeBag)
        }
    }
}
