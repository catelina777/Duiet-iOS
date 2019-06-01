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

    let content = BehaviorRelay<Content>(value: Content())
    private let disposeBag = DisposeBag()

    func configure(with viewModel: InputMealViewModel) {
        self.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(Observable.of(self))
            .bind(to: viewModel.input.selectedMealLabel)
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

    func configure(with view: UIView, at point: CGPoint) {
        // Add MealLavelView to SuperView
        view.addSubview(self)
        self.clipsToBounds = true
        let width = view.bounds.width * 0.3
        let height = width * 0.4
        let frame = CGRect(x: point.x - width / 2, y: point.y - height / 2, width: width, height: height)
        self.frame = frame

        // Setup Content Model
        let relativeX = point.x / view.frame.width
        let relativeY = point.y / view.frame.height
        let _content = Content(relativeX: Double(relativeX),
                               relativeY: Double(relativeY))
        self.content.accept(_content)
    }

    func Constraint(item: AnyObject,
                    _ attr: NSLayoutConstraint.Attribute,
                    to: AnyObject?,
                    _ attrTo: NSLayoutConstraint.Attribute,
                    constant: CGFloat = 0.0, multiplier: CGFloat = 1.0,
                    relate: NSLayoutConstraint.Relation = .equal,
                    priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
        let ret = NSLayoutConstraint(
            item: item,
            attribute: attr,
            relatedBy: relate,
            toItem: to,
            attribute: attrTo,
            multiplier: multiplier,
            constant: constant
        )
        ret.priority = priority
        return ret
    }
}
