//
//  MealCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CardView: UIView {}

class RoundedCardWrapperView: UIView {
    @IBOutlet weak var cardView: CardView!

    var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                self.transform = transform
            }, completion: nil)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.frame = bounds
        cardView.layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}

final class MealCardViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet private weak var caloriesLabel: UILabel! {
        didSet {
            caloriesLabel.layer.cornerRadius = 12
            caloriesLabel.clipsToBounds = true
        }
    }

    @IBOutlet private weak var checkmarkBackground: UIVisualEffectView! {
        didSet {
            checkmarkBackground.clipsToBounds = true
            checkmarkBackground.layer.cornerRadius = checkmarkBackground.bounds.width / 2
        }
    }

    @IBOutlet private weak var checkButton: UIButton!

    var isChecked: Bool = false {
        willSet {
            if newValue {
                checkButton.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                checkButton.tintColor = .systemRed
            } else {
                checkButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                checkButton.tintColor = R.color.componentMain()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isChecked = false
    }

    func configure(input: TodayViewModelInput, output: TodayViewModelOutput, state: TodayViewModelState, meal: Meal) {
        bindCheckButton(input: input, output: output, state: state, meal: meal)
        set(image: meal.imagePath)
        set(totalCalorie: meal.totalCalorie)
    }

    private func bindCheckButton(input: TodayViewModelInput, output: TodayViewModelOutput, state: TodayViewModelState, meal: Meal) {
        let isEditing =  checkButton.rx.tap
            .map { true }
            .share()

        isEditing
            .bind(to: input.isEditMode)
            .disposed(by: disposeBag)

        output.isEditMode
            .map { !$0 }
            .bind(to: checkmarkBackground.rx.isHidden)
            .disposed(by: disposeBag)

        checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }
                if me.isChecked {
                    // MARK: The amount of computation here is O (N)
                    let newMeals = state.deletionTargetMeals.value.filter { $0 != meal }
                    state.deletionTargetMeals.accept(newMeals)
                    me.isChecked.toggle()
                } else {
                    let newMeals = state.deletionTargetMeals.value + [meal]
                    state.deletionTargetMeals.accept(newMeals)
                    me.isChecked.toggle()
                }
            })
            .disposed(by: disposeBag)
    }

    private func set(image path: String) {
        PhotoRepository.shared.fetch(with: path)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func set(totalCalorie: Double) {
        caloriesLabel.text = UnitBabel.shared.convertWithSymbol(value: totalCalorie,
                                                                from: .kilocalories,
                                                                to: UnitCollectionModel.shared.state.unitCollectionValue.energyUnit)
    }
}
