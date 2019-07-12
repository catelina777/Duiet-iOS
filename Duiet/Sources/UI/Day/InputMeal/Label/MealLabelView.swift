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
        let calorie = self.viewModel.content.calorie
        let multiple = self.viewModel.content.multiple
        self.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"

        // MARK: - Send ViewModel of selected MealLabel
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewModel.input.selectedContent.on(.next(self.viewModel.content))
            })
            .disposed(by: disposeBag)

        // MARK: - Update text and notify new content
        viewModel.output.contentDidUpdate
            .bind(to: updateLabelText,
                  updateContent)
            .disposed(by: disposeBag)

        // MARK: - Hide myself when content is deleted
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

    var updateContent: Binder<Content> {
        return Binder(self) { me, content in
            me.viewModel.input.contentDidUpdate.on(.next(content))
        }
    }

    var hideMealLabel: Binder<Void> {
        return Binder(self) { me, _ in
            me.isHidden = true
        }
    }

    // TODO: - OLD
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

    // TODO: - OLD
    func configure(with content: Content) {
        self.content.accept(content)
        self.mealLabel.text = "\(Int(content.calorie * (content.multiple == 0 ? 1 : content.multiple)))"
    }
}
