//
//  InputPickerViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class InputPickerViewCell: RoundedTextFieldViewCell {

    let pickerView = UIPickerView()

    func configure(with cellType: CellType) {
        titleLabel.text = cellType.rawValue
        configurePickerView()
        configureToolBar()
    }

    private func configurePickerView() {
        pickerView.backgroundColor = R.color.contentBackground()
        pickerView.tintColor = R.color.main()
        textField.inputView = pickerView
    }

    private func configureToolBar() {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = R.color.contentBackground()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneButtonItem.tintColor = UIColor.black
        let items = [flexSpaceItem, doneButtonItem]
        toolBar.setItems(items, animated: true)
        textField.inputAccessoryView = toolBar
        doneButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
