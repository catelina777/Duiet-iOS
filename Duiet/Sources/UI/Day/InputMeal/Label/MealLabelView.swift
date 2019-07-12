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
    private let disposeBag = DisposeBag()

    func configure(with viewModel: InputMealViewModel) {
        // MARK: - Send ViewModel of selected MealLabel
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                viewModel.input.selectedViewModel.on(.next(self.viewModel))
            })
            .disposed(by: disposeBag)

        // MARK: - Update text and notify new content
        self.viewModel.output.contentDidUpdate
            .bind(to: updateLabelText,
                      updateContent)
            .disposed(by: disposeBag)

        // MARK: - Hide myself when content is deleted
        self.viewModel.output.hideView
            .bind(to: hideMealLabel)
            .disposed(by: disposeBag)
    }

    func initialize(with content: Content) {
        self.viewModel = MealLabelViewModel(content: content)
        let calorie = self.viewModel.content.calorie
        let multiple = self.viewModel.content.multiple
        self.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
    }

    var updateLabelText: Binder<Content> {
        return Binder(self) { me, content in
            guard !content.isInvalidated else { return }
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
}
