//
//  Content.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RealmSwift

final class Content: Object {

    @objc dynamic var name = ""
    @objc dynamic var calorie = 0.0
    @objc dynamic var multiple = 0.0

    @objc dynamic var relativeX = 0.0
    @objc dynamic var relativeY = 0.0

    @objc dynamic var date = Date()

    required convenience init(relativeX: Double, relativeY: Double) {
        self.init()
        self.relativeX = relativeX
        self.relativeY = relativeY
    }
}

extension Content {

    func convert(with viewModel: InputMealViewModel, view: LabelCanvasViewCell) -> MealLabelView {
        let mealLabelView = R.nib.mealLabelView.firstView(owner: nil)!
        let pointX = CGFloat(relativeX) * view.frame.width
        let pointY = CGFloat(relativeY) * view.frame.height
        let point = CGPoint(x: pointX, y: pointY)
        mealLabelView.configure(with: view, at: point)
        mealLabelView.configure(with: viewModel)
        mealLabelView.content.accept(self)
        mealLabelView.mealLabel.text = "\(Int(calorie * (multiple == 0 ? 1 : multiple)))"
        return mealLabelView
    }
}

extension List where Element == Content {

    func convert(with viewModel: InputMealViewModel, view: LabelCanvasViewCell) -> [MealLabelView] {
        return self.map { $0.convert(with: viewModel, view: view) }
    }
}
