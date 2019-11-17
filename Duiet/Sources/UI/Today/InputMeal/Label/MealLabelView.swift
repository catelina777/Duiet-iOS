//
//  MealLabelView.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxRelay
import RxSwift
import UIKit

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

    var viewModel: MealLabelViewModelProtocol!
    private let disposeBag = DisposeBag()

    static func build(food: Food) -> MealLabelView {
         let label = R.nib.mealLabelView.firstView(owner: nil)!
        label.initialize(with: food)
        return label
    }

    func initialize(with food: Food) {
        viewModel = MealLabelViewModel(food: food)
        let calorie = UnitBabel.shared.convert(value: food.calorie,
                                               from: .kilocalories,
                                               to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
        let multiple = viewModel.state.foodValue.multiple
        self.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
    }

    func configure(input: InputMealViewModelInput) {
        // MARK: - Send ViewModel of selected MealLabel
        rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let me = self else { return }
                input.selectedLabelViewModel.on(.next(me.viewModel))
                Haptic.impact(.light).generate()
            })
            .disposed(by: disposeBag)

        // MARK: - Update text and notify new content
        viewModel.output.contentDidUpdate
            .bind(to: updateLabelText)
            .disposed(by: disposeBag)

        // MARK: - Hide myself when content is deleted
        viewModel.output.hideView
            .bind(to: hideMealLabel)
            .disposed(by: disposeBag)
    }

    private var updateLabelText: Binder<Food> {
        Binder<Food>(self) { me, food in
            let calorie = UnitBabel.shared.convert(value: food.calorie,
                                                   from: .kilocalories,
                                                   to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
            let multiple = food.multiple
            me.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
        }
    }

    private var hideMealLabel: Binder<Void> {
        Binder(self) { me, _ in
            me.isHidden = true
        }
    }
}
