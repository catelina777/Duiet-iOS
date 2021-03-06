//
//  InputPickerViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/22.
//  Copyright © 2019 Duiet. All rights reserved.
//

import UIKit

class InputPickerViewCell: RoundedTextFieldViewCell {
    let pickerView = UIPickerView()

    func configure(with cellType: FillInformationCellType) {
        titleLabel.text = cellType.title
        configurePickerView()
        configureToolBar()
    }

    private func configurePickerView() {
        textField.inputView = pickerView
    }

    private func configureToolBar() {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneButtonItem.tintColor = .label
        let items = [flexSpaceItem, doneButtonItem]
        toolBar.setItems(items, animated: true)
        textField.inputAccessoryView = toolBar
        doneButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }
                me.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
