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
import ToolKits
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

    static func build(foodEntity: FoodEntity) -> MealLabelView {
         let label = R.nib.mealLabelView.firstView(owner: nil)!
        label.initialize(foodEntity: foodEntity)
        return label
    }

    func initialize(foodEntity: FoodEntity) {
        viewModel = MealLabelViewModel(foodEntity: foodEntity)
        let calorie = UnitBabel.shared.convert(value: foodEntity.calorie,
                                               from: .kilocalories,
                                               to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
        let multiple = viewModel.state.foodEntityValue.multiple
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
        viewModel.output.foodDidUpdate
            .bind(to: updateLabelText)
            .disposed(by: disposeBag)

        // MARK: - Hide myself when content is deleted
        viewModel.output.hideView
            .bind(to: hideMealLabel)
            .disposed(by: disposeBag)
    }

    private var updateLabelText: Binder<FoodEntity> {
        Binder<FoodEntity>(self) { me, foodEntity in
            let calorie = UnitBabel.shared.convert(value: foodEntity.calorie,
                                                   from: .kilocalories,
                                                   to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
            let multiple = foodEntity.multiple
            me.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
        }
    }

    private var hideMealLabel: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.isHidden = true
        }
    }
}
