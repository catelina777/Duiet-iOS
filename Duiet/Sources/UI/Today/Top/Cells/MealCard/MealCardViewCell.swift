//
//  MealCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift

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

final class MealCardViewCell: RxCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }

    @IBOutlet weak var caloriesLabel: UILabel! {
        didSet {
            caloriesLabel.layer.cornerRadius = 12
            caloriesLabel.clipsToBounds = true
        }
    }

    func configure(with meal: Meal, viewDidAppear: Observable<Void>) {
        set(image: meal.imagePath)
        set(totalCalorie: meal.totalCalorie)

        // MARK: - Reload image when the screen is displayed to avoid image not loading
        viewDidAppear
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }
                me.set(image: meal.imagePath)
            })
            .disposed(by: disposeBag)
    }

    private func set(image path: String) {
        PhotoManager.rx.fetchImage(with: path)
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func set(totalCalorie: Double) {
        caloriesLabel.text = "\(Int(totalCalorie))"
    }
}
