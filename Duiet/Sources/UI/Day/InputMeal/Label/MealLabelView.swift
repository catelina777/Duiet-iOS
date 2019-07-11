//
//  MealLabelView.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class MealLabelView: UIView {

    @IBOutlet private(set) weak var mealLabel: UILabel! {
        didSet {
            mealLabel.clipsToBounds = true
            mealLabel.layer.cornerRadius = 12
            mealLabel.layer.shadowColor = UIColor.black.cgColor
            mealLabel.layer.shadowRadius = 1
            mealLabel.layer.shadowOffset = CGSize(width: 0, height: 10)
            mealLabel.layer.shadowOpacity = 0.5
        }
    }

    var viewModel: MealLabelViewModel!

    let content = BehaviorRelay<Content>(value: Content())
    private let disposeBag = DisposeBag()

    func configure(with content: Content, viewModel: NewInputMealViewModel) {
        self.viewModel = MealLabelViewModel(content: content)

        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewModel.input.selectedMealLabelViewModel.on(.next(self.viewModel))
            })
            .disposed(by: disposeBag)

        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let me = self else { return }
                let content = me.viewModel.content
                viewModel.input.calorieTextInput.on(.next("\(content.calorie)"))
                viewModel.input.multipleTextInput.on(.next("\(content.multiple)"))
                viewModel.input.nameTextInput.on(.next(content.name))
            })
            .disposed(by: disposeBag)

        viewModel.output.updateLabelText
            .bind(to: updateLabelText)
            .disposed(by: disposeBag)

        viewModel.output.hideMealLabel
            .bind(to: hideMealLabel)
            .disposed(by: disposeBag)
    }

    var updateLabelText: Binder<Content> {
        return Binder(self) { me, content in
            let calorie = content.calorie
            let multiple = content.multiple
            me.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
        }
    }

    var hideMealLabel: Binder<Void> {
        return Binder(self) { me, _ in
            me.isHidden = true
        }
    }

    func configure(with viewModel: InputMealViewModel) {

        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewModel.input.selectedMealLabel.on(.next(self))
            })
            .disposed(by: disposeBag)

        // MARK: - Tell ViewModel new content information when tapping a new label
        self.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(content)
            .subscribe(onNext: {
                viewModel.input.calorieTextInput.on(.next("\($0.calorie)"))
                viewModel.input.multipleTextInput.on(.next("\($0.multiple)"))
                viewModel.input.nameTextInput.on(.next($0.name))
            })
            .disposed(by: disposeBag)
    }

    func configure(with content: Content) {
        self.content.accept(content)
        self.mealLabel.text = "\(Int(content.calorie * (content.multiple == 0 ? 1 : content.multiple)))"
    }
}
