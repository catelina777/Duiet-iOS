//
//  InputPickerViewCell.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class InputPickerViewCell: RxTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    let pickerView = UIPickerView()

    @IBOutlet weak var textField: MyTextField! {
        didSet {
            textField.font = R.font.montserratExtraBold(size: 24)
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
        }
    }

    func configure(with cellType: CellType) {
        titleLabel.text = cellType.rawValue
        configurePickerView()
        configureToolBar()
    }

    private func configurePickerView() {
        pickerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pickerView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        textField.inputView = pickerView
    }

    private func configureToolBar() {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
