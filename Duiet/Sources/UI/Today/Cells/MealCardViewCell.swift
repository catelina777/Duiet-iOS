//
//  MealCardViewCell.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CardView: UIView {

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
}

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

    var isAwaken = false

    func configure() {
        if !isAwaken {
            isAwaken = true
            let margin: CGFloat = 0.05
            let x = frame.width * margin
            let width = frame.width * (1 - margin * 2)
            let cardFrame = CGRect(x: x, y: 0, width: width, height: width)
            let wrrapedCardView = RoundedCardWrapperView(frame: cardFrame)
            addSubview(wrrapedCardView)
            print("awaken➕➕➕")
        }
    }
}
